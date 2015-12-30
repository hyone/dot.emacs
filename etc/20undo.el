(el-get-bundle undohist)
(el-get-bundle undo-tree)

;; undo
(setq undo-limit 100000)
(setq undo-strong-limit 150000)

;; undohist.el
(use-package undohist
  :init
  (setq undohist-directory (locate-user-emacs-file ".history/undohist"))
  :config
  (undohist-initialize))

;; undo-tree.el
(use-package undo-tree
  :config
  (global-undo-tree-mode t)

  ;; remove C-? from undo-tree-map because it conflicts with help-for-help
  (delq (assoc (aref (kbd "C-?") 0) undo-tree-map) undo-tree-map)

  (define-key undo-tree-map (kbd "M-/") 'undo-tree-redo)

  ;; visualizer mode map
  (define-key undo-tree-visualizer-mode-map "j" 'undo-tree-visualize-redo)
  (define-key undo-tree-visualizer-mode-map "k" 'undo-tree-visualize-undo)
  (define-key undo-tree-visualizer-mode-map "l" 'undo-tree-visualize-switch-branch-right)
  (define-key undo-tree-visualizer-mode-map "h" 'undo-tree-visualize-switch-branch-left)

  ;; when typping 'q', quit with delete-window
  (defadvice undo-tree-visualizer-quit
      (after delete-window activate)
    (delete-window)))
