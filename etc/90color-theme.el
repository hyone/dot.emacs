(el-get-bundle color-theme)

(with-eval-after-load-feature 'color-theme
  (let ((theme-dir (locate-user-emacs-file "share/themes")))
    (add-to-list 'load-path theme-dir)
    (setq color-theme-libraries theme-dir))

  (if (or window-system (featurep 'ns))
      ;; gui
      (progn
        (load "darkneon")
        (color-theme-darkneon))
    ;; console
    (progn
      (load "darkneon256")
      (color-theme-darkneon256))))
