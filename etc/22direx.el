(el-get-bundle direx)

(use-package direx
  ;; (setq direx:leaf-icon "  "
  ;;       direx:open-icon "▼ "
  ;;       direx:closed-icon "▶ ")

  :config
  ;; with popwin.el
  (use-package popwin
    :defer t
    :config
    (push '(direx:direx-mode :position left :width 25 :dedicated t)
          popwin:special-display-config))

  ;; with evil.el
  (use-package evil
    :defer t
    :config
    ;; use the standard direx bindings as a base
    (evil-make-overriding-map direx:direx-mode-map 'normal t)

    ;; adjust bindings
    (evil-declare-key 'normal direx:direx-mode-map
      "j" 'direx:next-item
      "k" 'direx:previous-item
      ;; use kill-this-buffer instead of quit-window
      ;; to avoid the problem that 'quit-window' function cause to change buffer in main window
      "q" 'kill-this-buffer)))
