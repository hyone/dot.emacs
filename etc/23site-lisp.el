;;-----------------------------------------------------------------------
;; package.el
;;-----------------------------------------------------------------------

(use-package evil
  :defer t
  :config
  (add-hook 'package-menu-mode-hook
            (lambda ()
              (message "PACKAGE-MENU-MODE-HOOK")
              (define-key package-menu-mode-map "j" 'evil-next-line)
              (define-key package-menu-mode-map "k" 'evil-previous-line)
              (define-key package-menu-mode-map "J" 'scroll-up)
              (define-key package-menu-mode-map "K" 'scroll-down)
              (define-key package-menu-mode-map "H" 'hyone:elscreen-cycle-previous)
              (define-key package-menu-mode-map "L" 'hyone:elscreen-cycle-next)
              (define-key package-menu-mode-map "/" 'evil-search-forward))))


;;-----------------------------------------------------------------------
;; auto-async-byte-compile
;;-----------------------------------------------------------------------

(el-get-bundle auto-async-byte-compile)

(use-package auto-async-byte-compile
  :config
  (setq auto-async-byte-compile-exclude-files-regexp
        (regexp-opt '("/program/emacs-lisp"
                      "/emacs.d/etc/"
                      "/etc/emacs/etc/"
                      "/etc/emacs-24.5/etc/"
                      "/emacs.d/share/"
                      "/etc/emacs/share/"
                      "/etc/emacs-24.5/share/"
                      "/emacs.d/junk/"
                      "/etc/emacs/junk/")))

  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))


;;-----------------------------------------------------------------------
;; dircolors
;;-----------------------------------------------------------------------

(use-package dircolors)


;;-----------------------------------------------------------------------
;; recentf
;;-----------------------------------------------------------------------

(el-get-bundle recentf-ext)

(use-package recentf
  :defer 10
  :init
  ;; NOTE: must be set before (require 'recentf)
  (setq recentf-save-file (locate-user-emacs-file ".recentf"))

  :config
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))

  ;; automatically cleanup the recent list
  ;; each time Emacs has been idle that number of seconds.
  ;; (setq recentf-auto-cleanup 1800)

  ;; automatically save the file when emacs is on idle.
  (setq recentf-auto-save-timer
        (run-with-idle-timer 180 t 'recentf-save-list))

  (recentf-mode 1)

  (use-package recentf-ext)
)


;;-----------------------------------------------------------------------
;; grep-edit
;;-----------------------------------------------------------------------

(el-get-bundle grep-edit)


;;-----------------------------------------------------------------------
;; moccur
;;-----------------------------------------------------------------------

(el-get-bundle color-moccur)
(el-get-bundle moccur-edit)

(use-package color-moccur
  :defer t
  :config
  ;; when type 'q' and then close moccur, I also close all files opened by moccur.
  (setq kill-buffer-after-dired-do-moccur t))


;;-----------------------------------------------------------------------
;; jaspace.el
;;-----------------------------------------------------------------------

(use-package jaspace
  :config
  ;; make colorize (visible) to tab, zenkaku space, space
  ;; right after line feed.
  (when (boundp 'jaspace-modes)
    (setq jaspace-modes
          (append jaspace-modes
                  '(php-mode
                    yaml-mode
                    javascript-mode
                    ruby-mode
                    python-mode
                    rst-mode
                    emacs-lisp-mode
                    text-mode
                    fundamental-mode))))
  (when (boundp 'jaspace-alternate-jaspace-string)
    (setq jaspace-alternate-jaspace-string "□"))
  (when (boundp 'jaspace-highlight-tabs)
    (setq jaspace-highlight-tabs ?^))

  (add-hook 'jaspace-mode-hook
            (lambda()
              (progn
                (when (boundp 'show-trailing-whitespace)
                  (setq show-trailing-whitespace t))
                )))

  (add-hook 'jaspace-mode-off-hook
            (lambda()
              (when (boundp 'show-trailing-whitespace)
                (setq show-trailing-whitespace nil)))))


;;-----------------------------------------------------------------------
;; session.el
;;-----------------------------------------------------------------------

(el-get-bundle session)

(use-package session
  :config
  (setq session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 50)
                                  (session-file-alist 500 t)
                                  (file-name-history 10000)))

  (add-hook 'after-init-hook 'session-initialize)

  ;; default length of file-name-history is only 500, so we change it
  (setq session-globals-max-string 100000000)

  ;; set infinity to size of history (default 30)
  (setq history-length t)

  ;; remember the position of the cursor when closing a buffer,
  ;; because we want to also remember it for a read only file or a file that doesn't save.
  (setq session-undo-check -1)

  ;; delete duplication fo history
  ;; From http://www.bookshelf.jp/soft/meadow_27.html#SEC343
  (use-package cl)
  (defun minubuffer-delete-duplicate ()
    (let (list)
      (dolist (elt (symbol-value minibuffer-history-variable))
        (unless (member elt list)
          (push elt list)))
      (set minibuffer-history-variable (nreverse list))))

  (add-hook 'minibuffer-setup-hook 'minubuffer-delete-duplicate)
)


;;-----------------------------------------------------------------------
;; minibuf-isearch.el
;;-----------------------------------------------------------------------

(use-package minibuf-isearch)


;;-----------------------------------------------------------------------
;; ibuffer.el
;;-----------------------------------------------------------------------

(use-package ibuffer
  :defer t
  :config
  ;; align text vertically
  (setq ibuffer-formats
        '((mark modified read-only " " (name 30 30)
                " " (size 6 -1) " " (mode 16 16) " " filename)
          (mark " " (name 30 -1) " " filename))))


;;-----------------------------------------------------------------------
;; howm
;;-----------------------------------------------------------------------

(use-package howm
  :disabled t
  :config
  ;; (setq howm-menu-lang `ja)

  ;; save directory
  (setq howm-directory (expand-file-name "~/howm/"))

  ;; menu file
  ;; (setq howm-menu-file "~/howm/menu.howm")

  ;; display title when show list of recent mem
  (setq howm-list-recent-title t)

  ;; number of recentMemo in menu
  (setq howm-menu-recent-num 20)

  ;; display title when show list of all memo
  (setq howm-list-all-title t))


;;-----------------------------------------------------------------------
;; woman
;;-----------------------------------------------------------------------

(use-package woman
  :defer t
  :config
  (setq woman-fill-column 105)

  (setq woman-cache-filename (locate-user-emacs-file ".wmncache"))

  ;; don't open in new frame
  (setq woman-use-own-frame nil))


;;-----------------------------------------------------------------------
;; thing-opt.el
;;-----------------------------------------------------------------------

(el-get-bundle thing-opt)

(use-package thing-opt
  :config
  (define-thing-commands))


;;-----------------------------------------------------------------------
;; shell-pop.el
;;-----------------------------------------------------------------------

(el-get-bundle shell-pop)

(use-package shell-pop
  :defer t
  :config
  (custom-set-variables
   '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*"
                                  (lambda nil (ansi-term shell-pop-term-shell)))))
   '(shell-pop-term-shell "zsh"))

  (add-hook 'term-mode-hook
            (lambda () (setq autopair-dont-activate t))))


;;-----------------------------------------------------------------------
;; magit.el
;;-----------------------------------------------------------------------

(el-get-bundle magit)


;;-----------------------------------------------------------------------
;; smooth-scrolling.el
;;-----------------------------------------------------------------------

(el-get-bundle smooth-scrolling)
(use-package smooth-scrolling)


;;-----------------------------------------------------------------------
;; open-junk-file
;;-----------------------------------------------------------------------

(el-get-bundle open-junk-file)

(use-package open-junk-file
  :defer t
  :config
  (setq open-junk-file-format (locate-user-emacs-file "junk/%Y/%m/%d-%H%M%S.")))
