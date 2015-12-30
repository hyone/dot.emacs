;; Frame
;;-----------------------------------------------------------------------

;; Configuration of Initial Frame
;; (setq default-frame-alist
;;       (append (list  ;; '(foreground-color . "#333333")
;;                      ;; '(background-color . "#e0e0e0")
;;                      ;; '(background-color . "#d7cec8")
;;                      ;; '(border-color . "black")
;;                      ;; '(mouse-color . "white")
;;                      ;; '(cursor-color . "black")
;;                      ;; '(ime-font . "Nihongo-12") ; TrueType のみ
;;                      ;; '(font . "bdf-fontset")    ; BDF
;;                      ;; '(font . "private-fontset"); TrueType
;;                      ;; '(font . "9x15")
;;                         ;; ;; For Consolas
;;                         ;; '(width . 101)
;;                         ;; '(height . 60)
;;                         ;; For MeiryoKe_Console
;;                         '(width . 114)
;;                         '(height . 70)
;;                      ;; '(top . 15)
;;                      ;; '(left . 15)
;; )
;;               default-frame-alist))


;; disable startup message
(setq inhibit-startup-screen t)

;; case of GUI
(when (or window-system (featurep 'ns))
  (tool-bar-mode 0)
  ;; (menu-bar-mode nil)
  (scroll-bar-mode 0)
  (setq use-dialog-box nil))


;; elscreen
;;-----------------------------------------------------------------------
;; NOTE: elscreen ( on current version 2015/12/31 )
;;       must be loaded before both mode-line settings and color-themes

(el-get-bundle elscreen)

(use-package elscreen
  :init
  ;; NOTE: must be set before (elscreen-start)
  (setq elscreen-prefix-key "\C-t")

  :config
  ;; don't show screen number on mode-line
  (setq elscreen-display-screen-number nil)

  (elscreen-start))



;; mode-line
;;-----------------------------------------------------------------------

(defun hyone:short-buffer-directory (max-length)
  "Show up to 'max-length' characters of the current buffer directory name."
  (let ((dir (file-name-directory (or (buffer-file-name) ""))))
    (if dir
        (let* ((path (reverse (split-string (abbreviate-file-name dir) "/")))
               (output ""))
          (when (and path (equal "" (car path)))
            (setq path (cdr path)))
          (while (and path (< (length output) (- max-length 4)))
            (setq output (concat (car path) "/" output))
            (setq path (cdr path)))
          (when path
            (setq output (concat ".../" output)))
          output))))

(defun hyone:strip-left (s)
  (replace-regexp-in-string "^ *" "" s))

(line-number-mode t)
(column-number-mode t)

(setq eol-mnemonic-unix ":UNIX")
(setq eol-mnemonic-dos  ":DOS")
(setq eol-mnemonic-mac  ":MAC")

;; create custom mode line faces
(make-face 'mode-line-mode-face)
(make-face 'mode-line-directory-face)
(make-face 'mode-line-minor-mode-face)


(setq-default mode-line-format
              '("  "
                global-mode-string

                ;;    buffer name
                mode-line-buffer-identification
                " "

                ;;    directory
                (:propertize (:eval (let ((dir (hyone:short-buffer-directory 30)))
                                      (if dir (concat "(" dir ")"))))
                             face mode-line-directory-face)
                (4 . " ")

                " %["
                ;;    major mode
                (:propertize mode-name face mode-line-mode-face)
                ;;    minor modes
                (:propertize minor-mode-alist face mode-line-minor-mode-face)
                "%n" "%] "

                (-40 " "
                     (vc-mode ("[" (:eval (hyone:strip-left vc-mode)) "]"))
                     " "
                     mode-line-modified
                     " "
                     mode-line-mule-info
                     "  "
                     (line-number-mode "%l:")
                     (column-number-mode "%c ")
                     (-6 . "%p")
                     )))


;; abbrevate minor mode names

(defvar mode-line-cleaner-alist
  '(;; For minor-mode, first char is 'space'
    (yas-minor-mode      . " Yas")
    (paredit-mode        . " Par")
    (undo-tree-mode      . " UT")
    (flymake-mode        . " FlyMk")
    (flycheck-mode       . " FlyCk")
    (ruby-block-mode     . " rBL")
    (scala-electric-mode . " EL")
    (ruby-electric-mode  . " EL")
    (eldoc-mode          . "")
    (abbrev-mode         . "")
    (jaspace-mode        . "")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode           . "Py")
    (ruby-mode             . "Rb")
    (emacs-lisp-mode       . "El")
    (markdown-mode         . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr(assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          ;; (when (eq mode major-mode)
          ;;   (setq mode-name mode-str))
          )))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
