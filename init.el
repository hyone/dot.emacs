; -*- mode: Lisp -*-

(defun filter (condp lst)
  (delq nil
    (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

(defun walk-directory (dir action)
  (funcall action dir)
  (mapcar (lambda (x)
            (walk-directory x action))
    (filter 'file-directory-p
      (directory-files dir t "^[^\\.]" t))))

;; emacs home

(setq user-emacs-directory (file-name-directory load-file-name))


;; load-paths

;; set load-path recursively from site-lisp root directory
(let ((root (locate-user-emacs-file "site-lisp")))
  (when (file-directory-p root)
    (walk-directory root
      (lambda (d)
        (setq load-path (cons d load-path))))))

(add-to-list 'load-path (locate-user-emacs-file "lib"))


;; el-get

(add-to-list 'exec-path "/usr/local/bin")

(let ((versioned-dir (locate-user-emacs-file (format "bundle/%s" emacs-version))))
  (setq-default el-get-dir (expand-file-name "el-get" versioned-dir)
                package-user-dir (expand-file-name "elpa" versioned-dir)))

(add-to-list 'load-path (expand-file-name "el-get" el-get-dir))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))


;; use-package

(eval-and-compile
  (defvar use-package-verbose t)
  (el-get-bundle! "use-package"))

(el-get-bundle! diminish)
(require 'bind-key)


;; Load Global Configurations

(require 'debian-run-directories)

(let ((etc-dir (locate-user-emacs-file "etc")))
  (walk-directory etc-dir
    (lambda (x) (debian-run-directories x))))


;; Load Local Configurations

(let ((local-conf (expand-file-name "~/etc/local/emacs.local")))
  (if (file-readable-p local-conf)
    (load-file local-conf)))
