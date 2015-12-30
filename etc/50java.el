(el-get-bundle malabar-mode)

(add-hook 'java-mode-hook
          (lambda ()
            (c-set-offset 'arglist-close 0)

            ;; Anonymous Class like below:
            ;; public MethodRule watchman = new TestWatchman() {
            ;;     ...
            ;; *}
            (c-set-offset 'inexpr-class 0)

            ;; private enum State {
            ;;     SEND_REQUEST,
            ;;     *RECV_RESPONSE,
            ;;     ...
            (c-set-offset 'statement-cont 0)

            ;; indent half of c-basic-offset
            (c-set-offset 'func-decl-cont '*)))


;; malabar mode
;;-----------------------------------------------------------------------

;; (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
;;                                   global-semanticdb-minor-mode
;;                                   global-semantic-idle-summary-mode
;;                                   global-semantic-mru-bookmark-mode))
;; (semantic-mode 1)

;; (require 'malabar-mode)
;; (setq malabar-groovy-lib-dir (locate-user-emacs-file "site-lisp/malabar-1.5-SNAPSHOT/lib"))
;; (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))

;; (add-hook 'malabar-mode-hook
;;           (lambda ()
;;             (let ((map (lookup-key malabar-mode-map malabar-mode-key-prefix)))
;;               (define-key map "a" 'malabar-run-all-tests)
;;               (define-key map "j" 'malabar-jump-to-thing)
;;               (define-key map "p" 'malabar-visit-project-file)
;;               (define-key map "t" 'malabar-visit-corresponding-test)
;;               (define-key map "v" 'malabar-run-test)
;;               (define-key map (kbd "C-v") 'malabar-run-junit-test))))
