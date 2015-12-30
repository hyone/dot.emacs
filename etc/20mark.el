(el-get-bundle visible-mark)

(use-package visible-mark)
(use-package auto-mark
  :config
  ;; From http://www.emacswiki.org/emacs/AutoMark
  (setq auto-mark-command-class-alist
        '((anything . anything)
          (goto-line . jump)
          (indent-for-tab-command . ignore)
          (undo . ignore)))
  (setq auto-mark-command-classifiers
        (list (lambda (command)
                (if (and (eq command 'self-insert-command)
                         (eq last-command-char ? ))
                    'ignore))))
  (global-auto-mark-mode 1))
