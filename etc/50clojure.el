(el-get-bundle clojure-mode)
(el-get-bundle align-cljlet)
(el-get-bundle midje-mode)
(el-get-bundle cider)
(el-get-bundle ac-cider)
(el-get-bundle ac-nrepl)

;; set rbenv path to both exec-path and PATH.
(add-to-list 'exec-path "~/.lein/bin")
(setenv "PATH" (mapconcat 'identity exec-path ":"))


;;-----------------------------------------------------------------------
;; clojure-mode.el
;;-----------------------------------------------------------------------

(use-package clojure-mode
  :config
  (use-package hyone-util)
  (use-package hyone-key-combo)

  (add-to-list 'auto-mode-alist '("\\.cljs$" . clojurescript-mode))

  (defun hyone:clojure-find-project-file (path)
    (if (or (null path) (equal "" path))
        (progn (message (format "Not found %s" clojure-project-root-file)) nil)
      (let* ((dir          (file-name-directory path))
             (project-file (expand-file-name clojure-project-root-file dir)))
        (cond
         ((not (file-exists-p dir))
          (progn (message (format "%s does not exist." dir)) nil))
         ((file-exists-p project-file)
          project-file)
         (t
          (hyone:clojure-find-project-file
           (file-name-directory (replace-regexp-in-string "/$" "" dir))))))))

  (defun hyone:clojure-open-project-file (&optional path)
    "open project.clj file in the project that the path belongs.
if path is omitted, use the current buffer path."
    (interactive)
    (let* ((path         (or path (buffer-file-name)))
           (project-file (hyone:clojure-find-project-file path)))
      (if project-file
          (find-file project-file))))

  (defun hyone:clojurescript-repl ()
    "run ClojureScript repl in the project."
    (interactive)
    (let ((project-file (hyone:clojure-find-project-file (buffer-file-name))))
      (when project-file
        (cd (file-name-directory project-file))
        ;; avoid to raise an error like "CLOJURESCRIPT_HOME not configured."
        (remove-hook 'inferior-lisp-mode-hook 'clojurescript-start-cljs-repl t)
        (run-lisp "lein trampoline cljsbuild repl-listen")
        (let ((buffer (get-buffer "*inferior-lisp*")))
          (if buffer (switch-to-buffer buffer))))))

  (defun setup-clojure-mode-key-combo (map)
    (evil-key-combo-define 'insert map (kbd ";") '("; " " ;; "))
    (evil-key-combo-define 'insert map (kbd "[") 'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "{") 'key-combo-execute-orignal))

  ;; avoid to evaluate expressions when hit return to indend to add new line.
  (add-hook 'clojure-mode-hook
            (lambda ()
              (hyone:set-tab-width 2 t nil)
              (setq evil-shift-width 2)

              (define-key clojure-mode-map (kbd "C-c j") 'clojure-jack-in)
              (define-key clojure-mode-map (kbd "C-c p") 'hyone:clojure-open-project-file)

              (use-package evil
                :defer t
                :config
                (evil-define-key 'normal clojure-mode-map ",al" 'align-cljlet)
                (evil-define-key 'normal clojure-mode-map ",am" 'align-map)

                (evil-key-combo-define 'insert clojure-mode-map "'" 'key-combo-execute-orignal)
                (evil-define-key 'insert clojure-mode-map "'" 'self-insert-command)
                (evil-define-key 'insert clojure-mode-map "]" 'self-insert-command)

                (use-package key-combo
                  :config
                  (setup-clojure-mode-key-combo clojure-mode-map)))))


  ;; Fix paredit behaviors on REPL
  (defun hyone:repl-paredit-modify-syntax ()
    (modify-syntax-entry ?\{ "(}")
    (modify-syntax-entry ?\} "){")
    (modify-syntax-entry ?\[ "(]")
    (modify-syntax-entry ?\] ")[")
    (modify-syntax-entry ?~ "' ")
    (modify-syntax-entry ?, " ")
    (modify-syntax-entry ?^ "'")
    (modify-syntax-entry ?= "'"))

  ;; adjust indentation
  ;;---------------------------------

  (put-clojure-indent 'reduce 'defun)
  (put-clojure-indent 'swap! 1)
  (put-clojure-indent 'add-watch 2)
  (put-clojure-indent 'take-while 1)
                                        ; midje
  (put-clojure-indent 'fact 1)
                                        ; lazytest
  (put-clojure-indent 'describe 1)
  (put-clojure-indent 'do-it 1)
  (put-clojure-indent 'given 1)
  (put-clojure-indent 'it 1)


  ;;-----------------------------------------------------------------------
  ;; align-cljlet.el
  ;;-----------------------------------------------------------------------

  (use-package align-cljlet)


  ;;-----------------------------------------------------------------------
  ;; midje-mode.el
  ;;-----------------------------------------------------------------------

  (setq midje-mode-key-prefix (kbd "C-c ."))
  (use-package midje-mode)
  ;; (require 'clojure-jump-to-file)


  ;;-----------------------------------------------------------------------
  ;; cider
  ;;-----------------------------------------------------------------------

  (use-package cider
    :config
    ;; hide *nrepl-connection* , *nrepl-server* from buffers list
    (setq nrepl-hide-special-buffers t)

    (add-hook 'cider-mode-hook
              (lambda ()
                ))

    (add-hook 'cider-repl-mode-hook
              (lambda ()
                (setq evil-shift-width 2)

                ;; HACK: avoid to keybinds of cider-repl-mode-map affect clojure-mode-map keybinds
                (set-keymap-parent cider-repl-mode-map nil)

                ;; font-lock to same as clojure-mode
                ;; (setq cider-repl-use-clojure-font-lock t)

                (evil-declare-key 'normal cider-repl-mode-map
                  (kbd "C-c q") 'cider-quit
                  (kbd "C-x q") 'hyone:kill-other-buffer
                  (kbd "C-x Q") 'hyone:kill-other-buffer-and-window)

                (evil-declare-key 'insert cider-repl-mode-map
                  (kbd "RET")   'cider-repl-return
                  (kbd "M-j")   'paredit-newline
                  (kbd "C-p")   'cider-repl-previous-input
                  (kbd "C-n")   'cider-repl-next-input
                  (kbd "C-M-r") 'cider-repl-previous-matching-input
                  (kbd "C-M-s") 'cider-repl-next-matching-input
                  (kbd "C-u")   'cider-repl-kill-input
                  (kbd "C-x q") 'hyone:kill-other-buffer
                  (kbd "C-x Q") 'hyone:kill-other-buffer-and-window
                  ;; (kbd "C-c C-d") 'ac-nrepl-popup-doc
                  (kbd "C-a")   'cider-repl-bol)

                (if (functionp 'paredit-newline)
                    (evil-define-key 'insert cider-repl-mode-map (kbd "M-RET") 'paredit-newline)
                  (evil-define-key 'insert cider-repl-mode-map (kbd "M-RET") 'newline-and-indent))

                ;;    disable to insert automatically correspond character
                (evil-key-combo-define 'insert cider-repl-mode-map "'" 'key-combo-execute-orignal)
                )))

  ;; ;; ac-nrepl
  ;; ;;---------------------------------

  ;; (require 'ac-nrepl)
  ;; (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
  ;; (add-hook 'cider-mode-hook 'ac-nrepl-setup)

  ;; ;; ac-cider
  ;; ;;---------------------------------

  ;; (require 'ac-cider)
  ;; (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
  ;; (add-hook 'cider-mode-hook 'ac-cider-setup)
  ;; (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
  )
