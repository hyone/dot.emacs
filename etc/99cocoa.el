(el-get-bundle migemo)

(when (eq window-system 'ns)
  ;; font settings
  ;; ----------------------------------------------------------------------------

  ;; font name can be gotten by fc-list command
  (let ((fontspec-menlo    (font-spec :family "Menlo" :size 14 :weight 'normal :slant 'normal))
        (fontspec-hiragino (font-spec :family "Hiragino Kaku Gothic ProN" :size 16)))
    (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
    ;; japanese characters
    (dolist (target '(japanese-jisx0208
                      japanese-jisx0208-1978
                      japanese-jisx0212
                      japanese-jisx0213-1
                      japanese-jisx0213-2
                      japanese-jisx0213.2004-1
                      katakana-jisx0201))
      (set-fontset-font "fontset-menlokakugo" target fontspec-hiragino))
    ;; others
    (set-fontset-font "fontset-menlokakugo" '(#x0080 . #x024F) fontspec-menlo)  ; 分音符付きラテン
    (set-fontset-font "fontset-menlokakugo" '(#x0370 . #x03FF) fontspec-menlo)  ; ギリシャ文字
    (set-fontset-font "fontset-menlokakugo" '#x276f fontspec-menlo) ; HEAVY RIGHT-POINTING ANGLE QUOTATION MARK ORNAMENT (used in terminal prompt)
    ;; (set-fontset-font "fontset-menlokakugo" 'unicode fontspec-hiragino nil 'append)

    (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo")))

  ;; keybinds
  ;; ----------------------------------------------------------------------------

  ; use command key as Meta
  (setq ns-command-modifier 'meta)
  ; use option key as Super
  (setq ns-alternate-modifier 'super)
  ; use function key as Hyper
  (setq ns-function-modifier 'hyper)

  ;; etcetera
  ;; ----------------------------------------------------------------------------

  ;; open a file when drop 'n drap it
  (global-set-key [ns-drag-file] 'ns-find-file)

  ;; ;; enable to use emacs with AquaSKK
  ;; (mac-input-method-mode t)

  (setq default-frame-alist
      (append '(
                 ;; (border-color . "black")
                 ;; (mouse-color . "white")
                 ;; (cursor-color . "black")
                 ;; (alpha . (95 90))
                 (alpha . 92))
        default-frame-alist)))

;; Mac ( include Non-GUI )
(when (eq system-type 'darwin)
  (setq browse-url-generic-program "open")

  ;; migemo.el
  ;; ----------------------------------------------------------------------------

  (with-eval-after-load-feature 'migemo
    (setq migemo-command "/usr/local/bin/cmigemo")
    (setq migemo-options '("-q" "--emacs"))
    (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
    (setq migemo-user-dictionary nil)
    (setq migemo-regex-dictionary nil)
    (setq migemo-coding-system 'utf-8-unix)
    (load-library "migemo")

    (migemo-init)))
