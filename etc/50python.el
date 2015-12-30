(el-get-bundle python-mode)
(el-get-bundle pymacs)

(use-package python-mode
  :mode (("\\.py$" . python-mode)
         ("python" . python-mode))
  :config
  (setq py-python-command "ipython")
  ;; (setq py-python-command-args '("--colors=Linux"))

  ;; py-shell
  (add-hook 'py-shell-hook
            (lambda ()
              (when (featurep 'evil)
                (evil-define-key 'insert py-shell-map (kbd "C-n") 'comint-next-input)
                (evil-define-key 'insert py-shell-map (kbd "C-p") 'comint-previous-input)
                (evil-define-key 'insert py-shell-map (kbd "C-c q") 'kill-buffer-and-window))))

  (defun py3-shell ()
    (interactive)
    (let ((old py-python-command))
      (setq py-python-command "python3")
      (py-shell)
      (setq py-python-command old)))

  ;; with pymacs
  (use-package pymacs
    :config
    (add-hook 'python-mode-hook
              (lambda () (require 'pycomplete))))

  ;; with auto-complete
  (use-package auto-complete
    :defer t
    :config
    (setq ac-source-python
          '((prefix "\\(?:\\.\\|->\\)\\(\\(?:[a-zA-Z_][a-zA-Z0-9_]*\\)?\\)" nil 1)
            (candidates . ac-py-candidates)
            (requires . 0)))

    (defun ac-py-candidates ()
      (pycomplete-pycomplete (py-symbol-near-point) (py-find-global-imports)))

    ;; py-complete コマンドがなぜかうまく動かないのでとりあえずコメントアウト
    ;; (add-hook 'python-mode-hook
    ;;           (lambda ()
    ;;             (make-local-variable 'ac-sources)
    ;;             (setq ac-sources (append ac-sources '(ac-source-python)))))
    ))
