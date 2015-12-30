(use-package cmuscheme
  :init
  (setq scheme-program-name "gosh -i")

  :config
  (use-package evil
    :defer t
    :config
    (use-package hyone-key-combo)

    (add-hook 'scheme-mode-hook
              (lambda ()
                (evil-key-combo-define 'insert scheme-mode-map "'" 'key-combo-execute-orignal)))

    (add-hook 'inferior-scheme-mode-hook
              (lambda ()
                (evil-key-combo-define 'insert inferior-scheme-mode-map "'" 'key-combo-execute-orignal)
                (evil-define-key 'insert inferior-scheme-mode-map (kbd "C-n") 'comint-next-input)
                (evil-define-key 'insert inferior-scheme-mode-map (kbd "C-p") 'comint-previous-input)))

    (add-hook 'scheme-mode-hook
              (lambda ()
                (evil-key-combo-define 'insert scheme-mode-map "'" 'key-combo-execute-orignal))))

  (defun scheme-shell (&optional other-window-p)
    "Run scheme interactive shell."
    (interactive)
    (funcall
     (if other-window-p 'switch-to-buffer 'switch-to-buffer-other-window)
     (get-buffer-create "*scheme-shell*"))
    (run-scheme scheme-program-name))

  (use-package popwin
    :defer t
    :config
    (push '("*scheme-shell*") popwin:special-display-config)))
