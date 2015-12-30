(el-get-bundle yasnippet)
(el-get-bundle yasnippet-snippets)

(use-package yasnippet
  :config
  (setq yas-fallback-behavior 'call-other-command)

  ;; snippets dir
  (setq yas-snippet-dirs
        (list
         ;; put custom snippet dir first because it becomes the default dir to save a new snippet.
         (locate-user-emacs-file "share/snippets")
         (expand-file-name "yasnippet-snippets" el-get-dir)))

  ;; when region is active, replace $0 to contents of region
  (setq yas-wrap-around-region t)

  ;; TAB to trigger another snippet expansion inside the snippet field
  (setq yas-triggers-in-field t)

  ;; make only punctuation sequence as snippet key,
  ;; i.e. when typing "world.<TAB>", enable "." as snippet key.
  (setq yas-key-syntaxes (list "." "w" "w_" "w_." "^ "))

  ;; snippet mode
  (setq auto-mode-alist (cons '("mysnippets/" . snippet-mode) auto-mode-alist))

  (yas-global-mode 1)


  ;; with anything.el
  (use-package anything
    :config
    ;; anyting-yasnippet
    ;; From http://d.hatena.ne.jp/sugyan/20120111/1326288445
    ;; use anything interface as prompt to select from multiple snippets candidates.
    (defun hyone:yas/anything-prompt (prompt choices &optional display-fn)
      (let* ((names (loop for choice in choices
                          collect (or (and display-fn (funcall display-fn choice))
                                      coice)))
             (selected (anything-other-buffer
                        `(((name . ,(format "%s" prompt))
                           (candidates . names)
                           (action . (("Insert snippet" . (lambda (arg) arg))))))
                        "*anything yas/prompt*")))
        (if selected
            (let ((n (position selected names :test 'equal)))
              (nth n choices))
          (signal 'quit "user quit!"))))

    (custom-set-variables '(yas/prompt-functions '(hyone:yas/anything-prompt)))))
