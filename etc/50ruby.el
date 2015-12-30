(el-get-bundle inf-ruby)
(el-get-bundle ruby-block)
(el-get-bundle ruby-electric)
(el-get-bundle ruby-end)
(el-get-bundle ruby-mode)
(el-get-bundle rspec-mode)
(el-get-bundle yari)

(use-package ruby-mode
  :mode (("\\.rake$" . ruby-mode)
         ("\\.gemspec$" . ruby-mode)
         ("\\.ru$" . ruby-mode)
         ("Rakefile$" . ruby-mode)
         ("Gemfile$" . ruby-mode)
         ("Capfile$" . ruby-mode))
  :config
  ;; set rbenv path to both exec-path and PATH.
  (add-to-list 'exec-path "~/.rbenv/shims/")
  (setenv "PATH" (mapconcat 'identity exec-path ":"))

  ;; with evil.el
  (add-hook 'ruby-mode-hook
            (lambda ()
              (modify-coding-system-alist 'file "\\.rb$" 'utf-8)
              (modify-coding-system-alist 'file "\\.rhtml$" 'utf-8)

              (setq evil-shift-width 2)

              ;; avoid to corrupt with yasnippet trigger key
              (define-key ruby-mode-map "\t" nil)

              ;; Fix some keys
              (when (featurep 'evil)
                ;; C-c C-l    ruby-load-file
                ;; C-c C-z    switch-to-ruby
                ;; C-c C-r    ruby-send-region

                (evil-declare-key 'normal ruby-mode-map
                  (kbd "C-c C-g") 'ruby-send-region-and-go
                  (kbd "C-c ]")   'rsense-jump-to-definition)

                (evil-declare-key 'insert ruby-mode-map
                  (kbd "RET") (lambda () (interactive)
                                (hyone:newline-dwim 'ruby-electric-return))
                  " " (lambda (arg)
                        (interactive "p")
                        (hyone:insert-space-dwim arg 'ruby-electric-space)))

                (setup-ruby-mode-key-combo ruby-mode-map))))

  (defun setup-ruby-mode-key-combo (map)
    (use-package hyone-key-combo)
    (evil-key-combo-define 'insert map (kbd "|") '(" | " "|`!!'|" " || ")))

  (use-package ruby-electric
    :config
    (add-hook 'ruby-mode-hook
              (lambda () (ruby-electric-mode))))

  (use-package ruby-mode
    :config
    (add-hook 'ruby-mode-hook
              (lambda ()
                (define-key ruby-mode-map (kbd "C-c h") 'yari-anything))))

  (use-package ruby-block
    :config
    (ruby-block-mode t))


  (use-package flymake
    :defer t
    :config
    (defvar flymake-ruby-err-line-patterns '(("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)))
    (defvar flymake-ruby-allowed-file-name-masks '((".+\\.\\(rb\\|rake\\)$" flymake-ruby-init)
                                                   ("Rakefile$" flymake-ruby-init)))

    ;; Not provided by flymake itself, curiously
    (defun flymake-create-temp-in-system-tempdir (filename prefix)
      (make-temp-file (or prefix "flymake-ruby")))

    ;; Invoke ruby with '-c' to get syntax checking
    (defun flymake-ruby-init ()
      (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
                               'flymake-create-temp-in-system-tempdir))))

    (defun flymake-ruby-load ()
      (interactive)
      (set (make-local-variable 'flymake-allowed-file-name-masks) flymake-ruby-allowed-file-name-masks)
      (set (make-local-variable 'flymake-err-line-patterns) flymake-ruby-err-line-patterns)
      (flymake-mode t))

    ;; (add-hook 'ruby-mode-hook 'flymake-ruby-load)
    )
)

(use-package inf-ruby
  :config
  (autoload 'ansi-color-for-comint-mode-on "ansi-color"
    "Set ansi-color-for-cominit-mode-on to t.")

  (if (executable-find "pry")
      (progn
        ;; using pry instead of irb
        (add-to-list 'inf-ruby-implementations '("pry" . "pry"))
        (setq inf-ruby-default-implementation "pry")
        (setq inf-ruby-first-prompt-pattern "^\\[[0-9]+\\] pry *[a-zA-Z0-9\\.\\-]* *\\((.*)\\)> *")
        (setq inf-ruby-prompt-pattern "^\\[[0-9]+\\] pry *[a-zA-Z0-9\\.\\-]* *\\((.*)\\)[>*\"'] *"))
    (progn
      ;; Adjust setting to the customized irb environment
      (setq ruby-program-name "irb -U --noreadline")))

  (add-hook 'inf-ruby-mode-hook
            (lambda ()
              (when (featurep 'evil)
                (setq evil-shift-width 2)

                (define-key inf-ruby-mode-map (kbd "C-M-l") nil)
                (define-key inf-ruby-mode-map (kbd "C-n") 'comint-next-input)
                (define-key inf-ruby-mode-map (kbd "C-p") 'comint-previous-input)
                (define-key inf-ruby-mode-map (kbd "C-c q") 'kill-buffer-and-window))

              ;; enable escape sequence notation in inf-ruby
              (ansi-color-for-comint-mode-on)))

  (use-package ruby-mode
    :defer t
    :config
    (add-hook 'ruby-mode-hook
              (lambda ()
                (inf-ruby-keys))))

  (use-package popwin
    :defer t
    :config
    (push '("*ruby*" :stick t) popwin:special-display-config)))

;; rspec-mode
(use-package rspec-mode
  :config
  ;; use 'rspec' command instead of 'rake spec'
  (setq rspec-spec-command "rspec")
  (setq rspec-use-rake-flag nil))

