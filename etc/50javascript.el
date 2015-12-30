(el-get-bundle js2-mode)
; (el-get-bundle jslint-v8 :git "https://github.com/valeryz/jslint-v8.git")

; to enable "byte-comple-file js2.el"
(unless (boundp 'warning-suppress-types)
  (setq warning-suppress-types nil))

(use-package js2-mode
  :mode (("\\.js$" . js2-mode)
         ("\\.json$" . js2-mode))
  :config
  (use-package hyone-util)

  (add-hook 'js2-mode-hook
            (lambda ()
              (when (featurep 'evil)
                ;; add auto-indent feature to js2 mode enter key
                (evil-define-key 'insert js2-mode-map (kbd "RET")
                  (lambda () (interactive)
                    (hyone:newline-dwim 'js2-enter-key)
                    (indent-for-tab-command)))

                (js-mode-key-combo-setup js2-mode-map))

              ;; indentation
              (js-mode-indentation-setup)))

  (defun js-mode-init ()
    (setup-js-mode-key-combo js-mode-map)
    ;; indentation
    (setup-js-mode-indentation))

  (defun js-mode-indentation-setup ()
    ;; using espresso.el for indentation
    (use-package espresso)
    (hyone:set-tab-width 2 t nil)
    (setq evil-shift-width 2)
    (setq espresso-indent-level 2
          espresso-expr-indent-offset 2
          indent-tabs-mode nil)
    (set (make-local-variable 'indent-line-function) 'espresso-indent-line))

  (defun js-mode-key-combo-setup (map)
    (use-package hyone-key-combo)
    (evil-key-combo-define 'insert map (kbd "=") '(" = " " == " " === " "==")))

  ;; flymake.el
  (use-package flymake
    :defer t
    :config
    (setq jslint-v8-shell "v8")

    (add-hook 'js2-mode-hook
              (lambda () (flymake-mode t)))))
