(el-get-bundle flycheck)
(el-get-bundle flycheck-pos-tip)

(use-package flycheck
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (flycheck-pos-tip-mode))
