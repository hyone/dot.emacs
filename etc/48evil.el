(el-get-bundle evil)
(el-get-bundle evil-surround)
(el-get-bundle browse-kill-ring)
(el-get-bundle dash-at-point)

(require 'hyone-util)

(use-package evil
  :config
  (evil-mode 1)

  ;; Enable evil mode in *Messages* buffer
  (let ((messages-buf (get-buffer "*Messages*")))
    (when messages-buf
      (with-current-buffer messages-buf
        (evil-mode t))))

  ;;-----------------------------------------------------------------------
  ;; Settings
  ;;-----------------------------------------------------------------------

  ;; undo point を細かく設定
  (setq evil-want-fine-undo t)

  ;; disable keybind to turn skk-mode on in normal mode
  (define-key evil-normal-state-map (kbd "<s-escape>") 'hyone:noop)

  ;; turn ime off when entering normal mode
  (add-hook 'evil-normal-state-entry-hook 'hyone:skk-turn-off)
  ;; turn ime off when entering minibuffer mode
  (add-hook 'minibuffer-setup-hook 'hyone:skk-turn-off)


  ;; change face by evil state
  ;;---------------------------------------------------------

  ;; cursor
  (setq evil-default-cursor #'hyone:evil-cursor)

  (setq hyone:evil-cursors
        '((insert  . ("khaki2" . bar))
          (default . ("dark orange" . box))))

  (defun hyone:evil-cursor ()
    (let* ((conf (or (assoc evil-state hyone:evil-cursors)
                     (assoc 'default hyone:evil-cursors)))
           (color (cadr conf))
           (type (cddr conf)))
      (set-cursor-color color)
      (setq cursor-type type)))

  ;; modeline
  (defvar hyone:evil-mode-line-colors
    '((normal   . nil)
      ;; (normal   . "gridColor")
      (insert   . "khaki2")
      ;; (insert   . "MediumPurple1")
      (visual   . "CornflowerBlue")
      (operator . "PaleGreen")
      (emacs    . "red1"))
    "mode-line colors by each evil state")

  (defun hyone:evil-refresh-mode-line-color ()
    (set-face-foreground 'mode-line-buffer-id
                         ;; 'mode-line-evil-mode-face 
                         (cdr (assq evil-state hyone:evil-mode-line-colors))))

  (defadvice evil-refresh-mode-line (after hyone:evil-modeline-color activate)
    (hyone:evil-refresh-mode-line-color))

  (defadvice set-buffer (after hyone:evil-modeline-color activate)
    (hyone:evil-refresh-mode-line-color))

  (add-hook 'after-save-hook
            (lambda ()
              (hyone:evil-refresh-mode-line-color)))


  ;; normal mode
  ;;---------------------------------------------------------

  ;; disable the map C-t to pop-tag-mark
  (define-key evil-normal-state-map (kbd "C-t") nil)

  (define-key evil-normal-state-map (kbd "C-h") 'help-for-help)

  (define-key evil-normal-state-map "J" 'scroll-up)
  (define-key evil-normal-state-map "K" 'scroll-down)

  (require 'hyone-elscreen)
  (define-key evil-normal-state-map "H" 'hyone:elscreen-cycle-previous)
  (define-key evil-normal-state-map "L" 'hyone:elscreen-cycle-next)

  (define-key evil-normal-state-map "q" 'delete-window)
  (define-key evil-normal-state-map "Q" 'delete-other-windows)

  ;; insert one character with keeping normal mode
  (define-key evil-normal-state-map " " 'evil-insert-one-character)

  ;; insert blank line above the current line,
  ;; and move the cursor along with the current line.
  (define-key evil-normal-state-map (kbd "RET")
    '(lambda () (interactive)
       (move-beginning-of-line nil)
       (newline)))

  ;; insert blank line above the current line,
  ;; and keep the cursor at the current point.
  (define-key evil-normal-state-map (kbd "M-<RET>")
    '(lambda () (interactive)
       (move-beginning-of-line nil)
       (newline)
       (forward-line -1)))

  (define-key evil-normal-state-map (kbd "C-a") 'align-regexp)

  (define-key evil-normal-state-map (kbd "C-i") 'evil-jump-backward)
  (define-key evil-normal-state-map (kbd "C-o") 'evil-jump-forward)

  ;; with anything
  (use-package anything
    :defer t
    :config
    (define-key evil-normal-state-map (kbd "C-j") 'anything-for-buffers)
    (define-key evil-normal-state-map (kbd "C-l") 'anything-find-file)
    (define-key evil-normal-state-map "F"         'anything-find-file)
    (define-key evil-normal-state-map "R"         'anything-execute-extended-command)
    (define-key evil-normal-state-map (kbd "M-y") 'anything-show-kill-ring)
    (define-key evil-normal-state-map (kbd "C-z") 'anything-resume)
    (define-key evil-insert-state-map (kbd "C-z") 'anything-resume))

  ;; Remap original behaviour of C-z
  (define-key evil-normal-state-map (kbd "M-z") 'evil-emacs-state)
  (define-key evil-emacs-state-map  (kbd "M-z") 'evil-exit-emacs-state)

  (define-key evil-normal-state-map (kbd "M-:") 'execute-extended-command)

  ;; go to the first non-blank character in the current line
  (define-key evil-normal-state-map (kbd "M-^") 'elscreen-toggle)

  ;; Because anything-show-kill-ring doesn't work, use browse-kill-ring temporary.
  (use-package browse-kill-ring
    :config
    (define-key evil-normal-state-map (kbd "M-y") 'browse-kill-ring))


  ;; Prefix: C-x
  ;;----------------------------------------------
  ;; C-x u: undo-tree-visualize

  ;;  popwin.el
  (use-package popwin
    :defer t
    :config
    (global-set-key (kbd "C-x p") popwin:keymap)
    (global-set-key (kbd "C-x C-d") 'just-one-space))

  ;;  ibuffer.el
  (define-key evil-normal-state-map (kbd "C-x C-j") 'ibuffer)
  ;;  kill a buffer
  (define-key evil-normal-state-map (kbd "C-x k") 'kill-this-buffer)
  (define-key evil-normal-state-map (kbd "C-x K") 'hyone:kill-other-buffer)
  ;;  moccur.el
  (define-key evil-normal-state-map (kbd "C-x g") 'moccur)
  (define-key evil-normal-state-map (kbd "C-x G") 'search-buffers)


  ;; Prefix: C-c
  ;;----------------------------------------------

  (define-key evil-normal-state-map (kbd "C-c j") 'end-of-defun)
  (define-key evil-normal-state-map (kbd "C-c k") 'beginning-of-defun)

  ;; magit.el
  ;; execute magit-status on the other window
  (if (commandp 'magit-status)
      (define-key evil-normal-state-map (kbd "C-c v")
        (lambda () (interactive)
          (split-window-vertically)
          (other-window 1)
          (magit-status (file-name-directory (buffer-file-name))))))

  ;; see word in dash app
  (use-package dash-at-point
    :config
    (define-key evil-normal-state-map (kbd "C-c d") 'dash-at-point))

  ;; flycheck
  (use-package flycheck
    :defer t
    :config
    (define-key evil-normal-state-map (kbd "C-c n") 'flycheck-next-error)
    (define-key evil-normal-state-map (kbd "C-c p") 'flycheck-previous-error)
    (define-key evil-normal-state-map (kbd "C-c l") 'flycheck-list-errors))


  ;; Prefix: \
  ;;----------------------------------------------
  (define-key evil-normal-state-map "\\" nil)

  ;; flycheck
  (define-key evil-normal-state-map "\\e" 'flycheck-list-errors)

  (define-key evil-normal-state-map "\\q" 'evil-record-macro)
  (define-key evil-normal-state-map "\\r" 'quickrun)
  (define-key evil-normal-state-map "\\R" 'quickrun-with-arg)
  (define-key evil-normal-state-map "\\u" 'revert-buffer)

  (define-key evil-normal-state-map "\\ol" 'org-store-link)
  (define-key evil-normal-state-map "\\oa" 'org-agenda)
  (define-key evil-normal-state-map "\\or" 'remember)


  ;; Prefix: ,
  ;;----------------------------------------------
  (define-key evil-motion-state-map "," nil)

  (define-key evil-normal-state-map ",h" 'evil-window-top)
  (define-key evil-normal-state-map ",m" 'evil-window-middle)
  (define-key evil-normal-state-map ",l" 'evil-window-bottom)

  (define-key evil-normal-state-map ",c" 'hyone:yank-buffer-fullpath)
  (define-key evil-normal-state-map ",d" 'kill-buffer-and-window)
  (define-key evil-normal-state-map ",D" 'hyone:kill-other-buffer-and-window)
  (define-key evil-normal-state-map ",f" 'direx:jump-to-directory-other-window)
  (define-key evil-normal-state-map ",F" 'direx:find-directory-other-window)
  (define-key evil-normal-state-map ",e" 'eval-expression)
  (define-key evil-normal-state-map ",g" 'anything-do-grep)
  (define-key evil-normal-state-map ",H" 'anything-info-emacs)
  (define-key evil-normal-state-map ",i" 'anything-imenu)
  (define-key evil-normal-state-map ",k" 'kill-this-buffer)
  (define-key evil-normal-state-map ",K" 'hyone:kill-other-buffer)
  (define-key evil-normal-state-map ",l" 'evil-lookup)
  (define-key evil-normal-state-map ",m" (lambda () (interactive)
                                           (anything-mark-ring)
                                           (recenter)))
  (define-key evil-normal-state-map ",o" 'hyone:open)
  (define-key evil-normal-state-map ",p" 'hyone:find-file-pyblosxom-entry)

  (define-key evil-normal-state-map ",r" 'hyone:rename-file-and-buffer)
  (use-package yasnippet
    :defer t
    :config
    (define-key evil-normal-state-map ",s" 'yas/insert-snippet))
  (define-key evil-normal-state-map ",," 'hyone:comment-or-uncomment-region-or-line)


  ;; align
  (define-key evil-normal-state-map ",ar" 'align-regexp)
  (define-key evil-normal-state-map ",aR" 'hyone:align-repeat)
  (define-key evil-normal-state-map ",aa"
    (lambda () (interactive) (hyone:align-repeat-by-keyword "=>")))
  (define-key evil-normal-state-map ",aq"
    (lambda () (interactive) (hyone:align-repeat-by-keyword "<=")))
  (define-key evil-normal-state-map ",as"
    (lambda () (interactive) (hyone:align-repeat-by-keyword "->")))
  (define-key evil-normal-state-map ",aw"
    (lambda () (interactive) (hyone:align-repeat-by-keyword "<-")))
  (define-key evil-normal-state-map ",ae"
    (lambda () (interactive) (hyone:align-repeat-by-keyword "=")))
  (define-key evil-normal-state-map ",a "
    (lambda () (interactive)
      (if mark-active
          (let ((start (region-beginning))
                (end (region-end)))
            (hyone:align-repeat start end "\s+" 0)
            (indent-region start end)))))

  ;; Prefix: .
  ;;----------------------------------------------


  ;; Prefix: s
  ;;----------------------------------------------

  (define-key evil-normal-state-map "s" nil)

  ;; Prefix: g
  ;;----------------------------------------------

  (define-key evil-normal-state-map "gF" 'evil-beginning-of-defun)
  (define-key evil-normal-state-map "gf" 'evil-end-of-defun)
  ;; run REPL on the other window
  (define-key evil-normal-state-map "gh"  'run-haskell)
  (define-key evil-normal-state-map "gm"  'tuareg-run-ocaml)
  (define-key evil-normal-state-map "gy"  'py-shell)
  (define-key evil-normal-state-map "gp"  'py3-shell)
  (define-key evil-normal-state-map "gr"  'run-ruby)
  (define-key evil-normal-state-map "gs"  'scheme-shell)
  (define-key evil-normal-state-map "gl"  'slime-connect)
  (define-key evil-normal-state-map "gS"
    (lambda ()
      (interactive)
      (let ((buffer (get-buffer "*inferior-scala*")))
        (if buffer (switch-to-buffer buffer) (ensime-inf-run-scala)))))

  ;; Prefix: C-w (window)
  ;;----------------------------------------------

  (define-key evil-normal-state-map (kbd "C-w T") 'hyone:elscreen-create-with-current-buffer)
  (define-key evil-normal-state-map (kbd "C-w x") 'hyone:swap-windows)


  ;; insert mode
  ;;---------------------------------------------------------

  ;; C-f, C-s

  (define-key evil-insert-state-map (kbd "RET")
    (lambda () (interactive)
      (hyone:newline-dwim 'evil-ret)))

  (define-key evil-insert-state-map " "
    (lambda (arg)
      (interactive "p")
      (hyone:insert-space-dwim arg)))

  ;; disable default behavior to use yasnippet trigger key
  ;; (define-key evil-insert-state-map (kbd "C-o") nil)

  (define-key evil-insert-state-map (kbd "C-n") 'next-line)
  (define-key evil-insert-state-map (kbd "C-p") 'previous-line)

  (define-key evil-insert-state-map (kbd "C-d") 'delete-forward-char)

  (define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") 'end-of-line)

  (define-key evil-insert-state-map (kbd "C-w") 'hyone:backward-kill-word-like-vim-or-region)
  (define-key evil-insert-state-map (kbd "C-k") 'kill-line)
  (define-key evil-insert-state-map (kbd "C-u") 'hyone:backward-kill-line)
  (define-key evil-insert-state-map (kbd "C-y") 'yank)
  (define-key evil-insert-state-map (kbd "C-v") 'quoted-insert)
                                        ; Vim's i_CTRL-D behaviour ( same key binds as my Vim's one )
  (define-key evil-insert-state-map (kbd "C-q") 'hyone:evil-delete-indent)


                                        ; go to the first non-blank character in the current line
  (define-key evil-insert-state-map (kbd "C-^")
    (lambda () (interactive) (forward-to-indentation 0)))

  ;; (define-key evil-insert-state-map (kbd "M-w") 'hyone:evil-delete-indent)
  (define-key evil-insert-state-map (kbd "M-^") 'elscreen-toggle)
  (define-key evil-insert-state-map (kbd "M-y") 'browse-kill-ring)
  (define-key evil-insert-state-map (kbd "M-:") 'execute-extended-command)

                                        ; insert yasnippet
  (define-key evil-insert-state-map (kbd "C-x i") 'yas/insert-snippet)


  ;; key-combo
  ;;-----------------------------------------------------------------------

  (use-package key-combo
    :config
    ;; enable key combo whenever after change major mode
    ;; (because there is no hook whenever creating new buffer)
    (add-hook 'after-change-major-mode-hook
              (lambda ()
                (key-combo-mode 1)))

    (key-combo-define evil-insert-state-map (kbd "{") "{`!!'}")
    (key-combo-define evil-insert-state-map (kbd "(") "(`!!')")
    (key-combo-define evil-insert-state-map (kbd "[") "[`!!']")
    (key-combo-define evil-insert-state-map (kbd "'") "'`!!''")
    (key-combo-define evil-insert-state-map (kbd "\"") " \"`!!'\"")
    (key-combo-define evil-insert-state-map (kbd "=") '(" = " " == " "=="))
    (key-combo-define evil-insert-state-map (kbd "=>") " => ")
    (key-combo-define evil-insert-state-map (kbd "=~") " =~ ")
    (key-combo-define evil-insert-state-map (kbd ">")  '(">" " > " " >> " ">>"))
    (key-combo-define evil-insert-state-map (kbd ">=") " >= ")
    (key-combo-define evil-insert-state-map (kbd "<")  '("<" " < " " << " "<<"))
    (key-combo-define evil-insert-state-map (kbd "<=") " <= ")
    (key-combo-define evil-insert-state-map (kbd "<-") " <- ")
    (key-combo-define evil-insert-state-map (kbd "!") 'key-combo-execute-orignal)
    (key-combo-define evil-insert-state-map (kbd "!=") " != ")
    (key-combo-define evil-insert-state-map (kbd "+") '(" + " " ++ " "++"))
    (key-combo-define evil-insert-state-map (kbd "+=") " += ")
    (key-combo-define evil-insert-state-map (kbd "-") 'key-combo-execute-orignal)
    (key-combo-define evil-insert-state-map (kbd "-=") " -= ")
    (key-combo-define evil-insert-state-map (kbd "|") '(" | " " || "))
    (key-combo-define evil-insert-state-map (kbd "&") '("&" " && " "&&")))


  ;; text object
  ;;---------------------------------------------------------

  (define-key evil-outer-text-objects-map "f" 'evil-a-defun)


  ;; visual mode
  ;;---------------------------------------------------------

  (define-key evil-visual-state-map "K"  'scroll-down)
  (define-key evil-visual-state-map "R"  'anything-execute-extended-command)
  (define-key evil-visual-state-map ",c" 'hyone:comment-or-uncomment-region-or-line)
  (define-key evil-visual-state-map ",e" 'eval-region)


  ;;-----------------------------------------------------------------------
  ;; functions
  ;;-----------------------------------------------------------------------

  (defun hyone:evil-delete-indent (beg end)
    "delete indentation of a evil-shift-with"
    (interactive (hyone:region-mark-or-line))
    (if (and (not (use-region-p))
             (hyone:on-blank-line-p))
        ;; delete spaces of shiftwidth length
        (let* ((lw (- end beg))
               (sw evil-shift-width)
               (n (if (< lw sw) lw sw)))
          (back-to-indentation)
          (delete-backward-char n))
      (indent-rigidly beg end (- evil-shift-width))
      (back-to-indentation)))

  (evil-define-operator evil-insert-one-character (beg end type char)
    "Replace text from BEG to END with CHAR."
    :motion evil-forward-char
    (interactive "<R>"
                 (evil-save-cursor
                   ;; (evil-refresh-cursor 'replace)
                   (list (evil-read-key))))
    (when char
      (if (eq type 'block)
          (save-excursion
            (evil-apply-on-block 'evil-insert-one-character beg end nil char))
        (goto-char beg)
        (while (< (point) end)
          (if (eq (char-after) ?\n)
              (forward-char)
            (if (eq char ?\n)
                (newline)
              (insert-char char 1))))
        (if (eq char ?\n)
            (when evil-auto-indent
              (indent-according-to-mode))
          (goto-char (max beg (1- end)))))))


  (setq evil-move-defun-alist
        '((ruby-mode . (ruby-beginning-of-defun . ruby-end-of-defun))
          (c-mode    . (c-beginning-of-defun . c-end-of-defun))
          (js2-mode  . (js2-beginning-of-defun . js2-end-of-defun))))

  (evil-define-motion evil-beginning-of-defun (count)
    "Move the cursor to the beggining of the current function."
    :type exclusive
    (let* ((mode-defuns (cdr-safe (assq major-mode evil-move-defun-alist)))
           (begin-defun (or (car-safe mode-defuns) 'beginning-of-defun)))
      (funcall begin-defun count)))

  (evil-define-motion evil-end-of-defun (count)
    "Move the cursor to the end of the current function."
    :type exclusive
    (let* ((mode-defuns (cdr-safe (assq major-mode evil-move-defun-alist)))
           (end-defun (or (cdr-safe mode-defuns) 'end-of-defun)))
      (funcall end-defun count)))

  (defun evil-move-defun (count)
    "Move by defun"
    (let ((count (or count 1)))
      (evil-motion-loop (var count)
        (cond
         ((< var 0) (evil-beginning-of-defun 1))
         (t         (evil-end-of-defun 1))))))

  (evil-define-text-object evil-a-defun (count &optional beg end type)
    "Select a defun."
    (evil-an-object-range count beg end type #'evil-move-defun))


  ;;-----------------------------------------------------------------------
  ;; evil-surround.el
  ;;-----------------------------------------------------------------------

  (use-package evil-surround
    :config
    (global-evil-surround-mode 1))


  ;;-----------------------------------------------------------------------
  ;; ddskk
  ;;-----------------------------------------------------------------------

  (use-package skk
    :defer t
    :config
    (message "with-eval-after-load-feature 'skk")
    (add-hook 'skk-mode-hook
              (lambda ()
                (evil-define-key 'insert skk-j-mode-map " " 'skk-insert)
                (evil-define-key 'insert skk-jisx0208-latin-mode-map " " 'skk-insert))))
  )
