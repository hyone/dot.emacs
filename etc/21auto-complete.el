(el-get-bundle auto-complete)

(use-package auto-complete
  :init
  ;; history file
  (setq ac-comphist-file (locate-user-emacs-file ".history/ac-comphist.dat"))

  ;; dictionary files directory
  (add-to-list 'ac-dictionary-directories
               (locate-user-emacs-file "share/ac-dict"))

  :config
  (use-package auto-complete-config)

  (ac-config-default)

  ;; turn on by default
  (global-auto-complete-mode t)

  ;; add modes below to ac-modes in order to enable ac-mode in.
  (setq ac-modes
        (append ac-modes '(rst-mode
                           cider-mode
                           cider-repl-mode
                           coffee-mode
                           comint-mode
                           groovy-mode
                           haskell-cabal-mode
                           literate-haskell-mode
                           html-mode
                           markdown-mode
                           nxml-mode
                           nxhtml-mode
                           objc-mode
                           shell-mode
                           sql-mode
                           inferior-emacs-lisp-mode
                           inferior-haskell-mode
                           inferior-lisp-mode
                           inferior-ruby-mode
                           inferior-scheme-mode
                           tuareg-interactive-mode
                           ensime-inf-mode
                           scala-mode-inf)))

  ;; at least typing 3 chars, don't pop up completion candidates.
  (setq ac-auto-start 3)

  ;; delay show popup menu
  ;; (setq ac-auto-show-menu 1.2)
  ;; (setq ac-auto-show-menu nil)

  ;; case sensitive if typings have capitals
  ;; (setq ac-ignore-case 'smart)
  (setq ac-ignore-case nil)

  ;; default completion sources
  (set-default 'ac-sources '(ac-source-dictionary
                             ;; ac-source-yasnippet
                             ac-source-words-in-buffer
                             ac-source-words-in-same-mode-buffers
                             ac-source-filename))

  (setq ac-dwim t)

  ;; keybinds
  (setq ac-use-menu-map t)

  (add-hook 'auto-complete-mode-hook
            (lambda ()
              (mapcar (lambda (m)
                        (define-key (eval m) (kbd "C-y") 'ac-expand)
                        (define-key (eval m) (kbd "TAB") 'ac-expand)
                        (define-key (eval m) (kbd "C-o") 'ac-complete)
                        ;; (define-key (eval m) (kbd "C-s") 'auto-complete)
                                        ;    avoid return key to decide completion.
                        (define-key (eval m) "\r" nil)
                        (define-key (eval m) (kbd "<return>") nil)
                                        ;    to avoid corruption of global ( or other minor modes ) key mappings.
                        ;; (define-key (eval m) (kbd "TAB") 'ac-complete)
                                        ; (define-key (eval m) (kbd "TAB") nil)
                        (define-key (eval m) (kbd "<tab>") nil)
                        (define-key (eval m) (kbd "S-<tab>") nil)
                        (define-key (eval m) (kbd "C-M-n") nil)
                        (define-key (eval m) (kbd "C-M-p") nil)
                        (define-key (eval m) (kbd "M-n") nil)
                        (define-key (eval m) (kbd "M-p") nil)
                        )
                      '(ac-menu-map ac-complete-mode-map))
              ))

  ;; a command to add region string to the file of current major mode ac-dictionary-source file
  ;; From http://d.hatena.ne.jp/kitokitoki/20100627/p1

  (defvar auto-complete-dict-path (car ac-dictionary-directories))
  (defun append-region-to-auto-complete-dict ()
    (interactive)
    (when (and transient-mark-mode mark-active)
      (let ((path (expand-file-name (prin1-to-string major-mode) auto-complete-dict-path))
            (str (concat "\n" (buffer-substring-no-properties (region-beginning) (region-end)))))
        (with-temp-buffer
          (insert str)
          (append-to-file (point-min) (point-max) path))))))
