(el-get-bundle tuareg)

;; ; ocaml-mode
;; (setq auto-mode-alist
;;       (cons '("\\.ml[iylp]?$" . caml-mode) auto-mode-alist))
;; (autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
;; (autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)

;; tuareg-mode

(use-package tuareg-mode
  :mode ("\\.ml[iylp]?$" . tuareg-mode)
  :config

  ;; with evil.el
  (use-package evil
    :defer t
    :config
    (use-package hyone-key-combo
      :config
      (add-hook 'tuareg-mode-hook
                (lambda ()
                  (setq evil-shift-width 2)
                  (hyone:set-tab-width 2 t nil)

                  (evil-define-key 'insert tuareg-mode-map "'" 'self-insert-command)
                  (evil-define-key 'normal tuareg-mode-map (kbd "C-c C-l") 'tuareg-eval-buffer)
                  (evil-define-key 'insert tuareg-mode-map (kbd "C-c C-l") 'tuareg-eval-buffer)

                  (setup-tuareg-mode-key-combo tuareg-mode-map)))

      (add-hook 'tuareg-interactive-mode-hook
                (lambda ()
                  (setq evil-shift-width 2)
                  (hyone:set-tab-width 2 t nil)

                  (define-key tuareg-interactive-mode-map (kbd "C-j") nil)

                  (evil-declare-key 'insert tuareg-interactive-mode-map
                    "'"             'self-insert-command
                    (kbd "C-p")     'comint-previous-input
                    (kbd "C-n")     'comint-next-input
                    (kbd "RET")     'tuareg-interactive-send-input-end-of-phrase
                    (kbd "M-<RET>") 'tuareg-interactive-send-input-or-indent
                    (kbd "C-c u")   'comint-kill-input)

                  (setup-tuareg-mode-key-combo tuareg-interactive-mode-map)))

      (defun setup-tuareg-mode-key-combo (map)
        (evil-key-combo-define 'insert map (kbd "'")  '("'" "'`!!''"))
        (evil-key-combo-define 'insert map (kbd "+.") " +. ")
        (evil-key-combo-define 'insert map (kbd "-.") " -. ")
        (evil-key-combo-define 'insert map (kbd "*") '(" * "))
        (evil-key-combo-define 'insert map (kbd "*.") " *. ")
        (evil-key-combo-define 'insert map (kbd "/") '("/" " / "))
        (evil-key-combo-define 'insert map (kbd "/.") " /. ")
        (evil-key-combo-define 'insert map (kbd "->") " -> ")
        (evil-key-combo-define 'insert map (kbd "<>")  '" <> ")
        (evil-key-combo-define 'insert map (kbd ":")  '(" : " " :: "))
        (evil-key-combo-define 'insert map (kbd "@")  '("@" " @@ " "@@"))
        (evil-key-combo-define 'insert map (kbd "$")  '(" $ ")))
    )
  )
)

