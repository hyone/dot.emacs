(el-get-bundle ddskk)

(use-package skk-autoloads
  :config
  (global-set-key (kbd "<s-escape>")
                  (lambda () (interactive) (skk-mode 1)))
  (global-set-key "\C-x\C-j" 'skk-mode)
  (global-set-key "\C-xj" 'skk-auto-fill-mode)

  (setq skk-user-directory (locate-user-emacs-file "share/skk"))

  (setq skk-server-host "localhost")
  (setq skk-server-portnum 1178)

  (setq skk-jisyo-code 'utf-8-unix)

  ;; (setq skk-kakutei-key (kbd "C-m"))
  (setq skk-kakutei-key (kbd "<s-escape>"))

  ;; display precedently candidates have correct okuri-gana
  (setq skk-henkan-strict-okuri-precedence t)
  ;; check mistake okuri-gana whene regist KANJI
  (setq skk-check-okurigana-on-touroku t)

  (setq skk-keep-record t)

  ;; display candidates for completion
  (setq skk-dcomp-activate t)

  (setq skk-show-inline t)

  ;; display message in Japanese
  (setq skk-japanenese-message-and-error t)

  (setq skk-show-annotation t)

  ;; decide translation when we type not only [C-j] but also [Enter]
  (setq skk-egg-like-newline t)

  ;; ;;    turn JIS mode off, when minibuffer
  ;; (add-hook 'minibuffer-setup-hook
  ;;   '(lambda ()
  ;;      (when (boundp 'skk-latin-mode-on)
  ;;        (skk-latin-mode-on))))
  )
