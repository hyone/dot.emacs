;; Meadow ( Windows )
(when (featurep 'meadow)
  (setq tramp-default-method "plink")
  (setq-default tramp-shell-prompt-pattern "^[ $]+")
  (modify-coding-system-alist 'process "plink.exe" 'utf-8-unix))

;; Other ( Unix )
(when (not (featurep 'meadow))
  (require 'tramp)
  (setq tramp-default-method "ssh")
  (setq-default tramp-terminal-type "dumb")
  (setq tramp-rsh-end-of-line "\r"))

(setq-default tramp-completion-without-shell-p t)
(setq-default tramp-debug-buffer t)
(setq tramp-verbose 8)

(setq tramp-persistency-file-name (locate-user-emacs-file (format ".history/tramp-%s" user-full-name)))
