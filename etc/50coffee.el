(el-get-bundle coffee-mode)

(use-package coffee-mode
  :mode (("\\.coffee$" . coffee-mode)
         ("Cakefile" . coffee-mode))

  :config
  ;; set node.js path to both exec-path and PATH.
  (add-to-list 'exec-path "/usr/local/share/npm/bin")
  (setenv "PATH" (mapconcat 'identity exec-path ":"))

  (defun hyone:coffee-jump-to-compiled-js ()
    (interactive)
    (let ((path (buffer-file-name)))
      (if (and path (string-match "\\.coffee$" path))
          (find-file (replace-regexp-in-string "\\.coffee$" ".js" (buffer-file-name)))
        (message "Current buffer is not a coffeescript file."))))

  (defun setup-coffee-mode-key-combo (map)
    (evil-key-combo-define 'insert map (kbd "-") 'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "->")  " -> ")
    (evil-key-combo-define 'insert map (kbd "*")  " * ")
    (evil-key-combo-define 'insert map (kbd "*=")  " *= "))

  (add-hook 'coffee-mode-hook
            (lambda ()
              (use-package 'hyone-util
                :config
                (hyone:set-tab-width 2 t nil))

              (use-package evil
                :defer t
                :config
                (setq evil-shift-width 2)

                (evil-declare-key 'normal coffee-mode-map
                  (kbd "C-c r") 'coffee-compile-file
                  (kbd "C-c j") 'hyone:coffee-jump-to-compiled-js)

                (evil-declare-key 'visual coffee-mode-map
                  (kbd "C-c r") 'coffee-compile-region)

                (use-package hyone-key-combo
                  :config
                  (setup-coffee-mode-key-combo coffee-mode-map)))))


  ;; flymake
  ;;-----------------------------------------------------------------------

  (use-package flymake
    :defer t
    :config
    (setq flymake-coffeescript-err-line-patterns
          '(("\\(Error: In \\([^,]+\\), .+ on line \\([0-9]+\\).*\\)" 2 3 nil 1)))

    (defconst flymake-allowed-coffeescript-file-name-masks
      '(("\\.coffee$" flymake-coffeescript-init)))

    (defun flymake-coffeescript-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "coffee" (list local-file))))

    (defun flymake-coffeescript-load ()
      (interactive)
      (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
        (setq flymake-check-was-interrupted t))
      (ad-activate 'flymake-post-syntax-check)
      (setq flymake-allowed-file-name-masks
            (append flymake-allowed-file-name-masks
                    flymake-allowed-coffeescript-file-name-masks))
      (setq flymake-err-line-patterns flymake-coffeescript-err-line-patterns)
      (flymake-mode t))

    (add-hook 'coffee-mode-hook 'flymake-coffeescript-load)
    )
  )
