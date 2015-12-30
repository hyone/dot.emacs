(el-get-bundle mode-compile)

(use-package mode-compile
  :commands mode-compile
  :config
  ;; not to ask
  (setq mode-compile-always-save-buffer-p t)

  (setq mode-compile-never-edit-command-p t)
  (setq mode-compile-expert-p t)
  (setq mode-compile-reading-time 0)

  ;; size of complile window
  (setq compilation-window-height 25))
