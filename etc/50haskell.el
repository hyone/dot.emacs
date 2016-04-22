(el-get-bundle haskell-mode)

(use-package hyone-util)

(use-package haskell-mode
  :mode ("\\.hs-boot$" . haskell-mode)
  :config
  (use-package ghc
    :commands ghc-init)

  ;; Add to the path to commands installed by stack
  (when (eq system-type 'darwin)
    (add-to-list 'exec-path (expand-file-name "~/.local/bin")))

  (setq haskell-program-name "stack repl")

  ;; Using hlint as flymake check command
  (setq ghc-flymake-command t)

  (setq haskell-interactive-mode-eval-mode t)

  (defun setup-haskell-mode-key-combo (map)
    (evil-key-combo-define 'insert map (kbd "`")  " ``!!'` ")
    (evil-key-combo-define 'insert map (kbd "'")  '("'" "'`!!''"))
    (evil-key-combo-define 'insert map (kbd "-")  'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "->") " -> ")
    (evil-key-combo-define 'insert map (kbd "=<") "=<")
    (evil-key-combo-define 'insert map (kbd "=$") " =$ ")
    (evil-key-combo-define 'insert map (kbd "=$=")  " =$= ")
    (evil-key-combo-define 'insert map (kbd "=<<") " =<< ")
    (evil-key-combo-define 'insert map (kbd "==>") " ==> ")
    (evil-key-combo-define 'insert map (kbd "<=<") " <=< ")
    (evil-key-combo-define 'insert map (kbd "<*") " <* ")
    (evil-key-combo-define 'insert map (kbd ">") '(">" " >> " ">>" " >>> "))
    (evil-key-combo-define 'insert map (kbd "|") '(" | " " || " " <|> " " ||| "))
    (evil-key-combo-define 'insert map (kbd "&") '("&" " && " " &&& "))
    (evil-key-combo-define 'insert map (kbd "+") '(" + " " ++ " " +++ "))
    (evil-key-combo-define 'insert map (kbd ">>=") " >>= ")
    (evil-key-combo-define 'insert map (kbd "/")  'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "/=")  " /= ")
    (evil-key-combo-define 'insert map (kbd ":")  '(":" " :: " " : "))
    (evil-key-combo-define 'insert map (kbd "*")  '(" * " " <*> " " *** "))
    (evil-key-combo-define 'insert map (kbd "*>")  " *> ")
    (evil-key-combo-define 'insert map (kbd "$")  '(" $ " " $$ " " <$> "))
    (evil-key-combo-define 'insert map (kbd "$=")  " $= ")
    (evil-key-combo-define 'insert map (kbd "$(")  "$(`!!')")
    (evil-key-combo-define 'insert map (kbd "!")  "!")
    (evil-key-combo-define 'insert map (kbd "!!")  " !! ")
    (evil-key-combo-define 'insert map (kbd "\\") 'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "\\\\") " \\\\ ")
    (evil-key-combo-define 'insert map (kbd "[|") "[|`!!'|]")
    (evil-key-combo-define 'insert map (kbd "@") 'key-combo-execute-orignal)
    (evil-key-combo-define 'insert map (kbd "@?") "@?")
    (evil-key-combo-define 'insert map (kbd "@?=") " @?= ")
    (evil-key-combo-define 'insert map (kbd "@=") "@=")
    (evil-key-combo-define 'insert map (kbd "@=?") " @=? ")
    )


  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
  (add-hook 'haskell-mode-hook 'font-lock-mode)
  (add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

  (add-hook 'haskell-mode-hook
            (lambda ()
              ;; indent
              (hyone:set-tab-width 2 t nil)
              (setq haskell-indent-offset 2)
              (when (featurep 'evil)
                (setq evil-shift-width 2))

              (turn-on-haskell-indentation)
              ;; (turn-on-haskell-indent)

              ;; setup default haskell environment
              ;; (let ((hsenv-dir (expand-file-name  "~/.haskell/hsenv/env/")))
              ;;   (hsenv-activate-dir hsenv-dir))

              ;; keybinds
              (when (featurep 'evil)
                ;; C-c C-i: Displays the info of this expression in another window.
                ;; C-c C-t: Displays the type of this expression in the minibuffer.
                ;;          Type C-c C-t multiple time to enlarge the expression.
                (evil-define-key 'normal haskell-mode-map
                  (kbd "C-c h")   'anything-ghc-browse-document
                  (kbd "C-c C-l") 'inferior-haskell-load-file
                  (kbd "C-c s")   'ghc-display-errors)

                (evil-declare-key 'insert haskell-mode-map
                  (kbd "RET")     'newline
                  (kbd "M-<RET>") 'newline-and-indent
                  (kbd "C-c /")   'ghc-help-key)

                (setup-haskell-mode-key-combo haskell-mode-map)
                ;; key-combo is disabled for some reason, so enable it explicitlly
                (key-combo-mode 1))

              (ghc-init)

              (flymake-mode)))


  (add-hook 'inferior-haskell-mode-hook
            (lambda ()
              ;; indent
              (hyone:set-tab-width 2 t nil)
              (setq haskell-indent-offset 2)
              (when (featurep 'evil)
                (setq evil-shift-width 2))

              (when (featurep 'evil)
                (evil-declare-key 'insert inferior-haskell-mode-map
                  "'"         'self-insert-command
                  "`"         '(lambda () (interactive) (insert-pairs "`" "`"))
                  (kbd "C-n") 'comint-next-input
                  (kbd "C-p") 'comint-previous-input)

                (use-package hyone-key-combo
                  :config
                  (setup-haskell-mode-key-combo inferior-haskell-mode-map)))
                ;; (evil-key-combo-define 'insert inferior-haskell-mode-map (kbd ":") '(":" " : " " :: "))
              ))

  ;;-----------------------------------------------------------------------
  ;; haskell cabal mode
  ;;-----------------------------------------------------------------------

  (add-hook 'haskell-cabal-mode-hook
            (lambda ()
              (hyone:set-tab-width 2 t nil)
              (setq haskell-indent-offset 2)
              (when (featurep 'evil)
                (setq evil-shift-width 2))))


  ;;-----------------------------------------------------------------------
  ;; Auto Complete
  ;;-----------------------------------------------------------------------

  (use-package auto-complete
    :defer t
    :config
    (ac-define-source ghc-mod
      '((depends ghc)
        (candidates . (ghc-select-completion-symbol))
        (symbol . "s")
        (cache)))

    (add-hook 'haskell-mode-hook
              (lambda ()
                (add-to-list 'ac-sources 'ac-source-ghc-mod))))


  ;;-----------------------------------------------------------------------
  ;; Anything
  ;;-----------------------------------------------------------------------

  (use-package anything
    :defer t
    :config
    (use-package anything-config)
    (use-package anything-match-plugin)

    (defvar anything-c-source-ghc-mod
      '((name . "ghc-browse-document")
        (init . anything-c-source-ghc-mod)
        (candidates-in-buffer)
        (candidate-number-limit . 9999999)
        (action ("Open" . anything-c-source-ghc-mod-action))))

    (defun anything-c-source-ghc-mod ()
      (unless (executable-find "ghc-mod")
        (error "ghc-mod を利用できません。ターミナルで which したり、*scratch* で exec-path を確認したりしましょう"))
      (let ((buffer (anything-candidate-buffer 'global)))
        (with-current-buffer buffer
          (call-process "ghc-mod" nil t t "list"))))

    (defun anything-c-source-ghc-mod-action (candidate)
      (interactive "P")
      (let* ((pkg (ghc-resolve-package-name candidate)))
        (anything-aif (and pkg candidate)
            (ghc-display-document pkg it nil)
          (message "No document found"))))

    (defun anything-ghc-browse-document ()
      (interactive)
      (anything anything-c-source-ghc-mod)))


  ;;-----------------------------------------------------------------------
  ;; hsenv.el
  ;;-----------------------------------------------------------------------

  (use-package hsenv)


  ;;-----------------------------------------------------------------------
  ;; popwin.el
  ;;-----------------------------------------------------------------------

  (use-package popwin
    :defer t
    :config
    (push '("*GHC Info*") popwin:special-display-config)))
