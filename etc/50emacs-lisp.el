(el-get-bundle lispxmp)

(use-package hyone-key-combo
  :config
  (defun setup-emacs-lisp-mode-key-combo (map)
    (evil-key-combo-define 'insert map (kbd "'") 'key-combo-execute-orignal))

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'lispxmp)
              (evil-define-key 'normal emacs-lisp-mode-map (kbd "C-c C-l") 'find-function-at-point)
              (evil-define-key 'insert emacs-lisp-mode-map "'" 'self-insert-command)
              (setup-emacs-lisp-mode-key-combo emacs-lisp-mode-map)))

  (add-hook 'ielm-mode-hook
            (lambda ()
              (evil-declare-key 'insert inferior-emacs-lisp-mode-map
                (kbd "C-n")   'comint-next-input
                (kbd "C-p")   'comint-previous-input
                "'"           'self-insert-command
                (kbd "M-RET") 'newline-and-indent)
              (setup-emacs-lisp-mode-key-combo inferior-emacs-lisp-mode-map))))
