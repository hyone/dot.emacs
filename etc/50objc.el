(require 'hyone-key-combo)

(use-package evil
  :defer t
  :config
  (use-package hyone-key-combo)
  (add-hook 'objc-mode-hook
            (lambda ()
              (evil-key-combo-define 'insert objc-mode-map (kbd "\"") 'key-combo-execute-orignal)
              (evil-key-combo-define 'insert objc-mode-map (kbd "@") 'key-combo-execute-orignal)
              (evil-key-combo-define 'insert objc-mode-map (kbd "@\"") "@\"`!!'\""))))
