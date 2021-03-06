(require 'package)

;;------------------------------------------------------------------------------
;; Patch up annoying package.el quirks
;;------------------------------------------------------------------------------
(defadvice package-generate-autoloads (after close-autoloads (name pkg-dir) activate)
  "Stop package.el from leaving open autoload files lying around."
  (let ((path (expand-file-name (concat
                                 ;; name is string when emacs <= 24.3.1,
                                 (if (symbolp name) (symbol-name name) name)
                                 "-autoloads.el") pkg-dir)))
    (with-current-buffer (find-file-existing path)
      (kill-buffer nil))))


;;------------------------------------------------------------------------------
;; Add support to package.el for pre-filtering available packages
;;------------------------------------------------------------------------------
(defvar package-filter-function nil
  "Optional predicate function used to internally filter packages used by package.el.

The function is called with the arguments PACKAGE VERSION ARCHIVE, where
PACKAGE is a symbol, VERSION is a vector as produced by `version-to-list', and
ARCHIVE is the string name of the package archive.")

(defadvice package--add-to-archive-contents
  (around filter-packages (package archive) activate)
  "Add filtering of available packages using `package-filter-function', if non-nil."
  (when (or (null package-filter-function)
      (funcall package-filter-function
         (car package)
         (funcall (if (fboundp 'package-desc-version)
          'package--ac-desc-version
        'package-desc-vers)
            (cdr package))
         archive))
    ad-do-it))

;;------------------------------------------------------------------------------
;; On-demand installation of packages
;;------------------------------------------------------------------------------
(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


;;------------------------------------------------------------------------------
;; Standard package repositories
;;------------------------------------------------------------------------------

;; We include the org repository for completeness, but don't use it.
;; Lock org-mode temporarily:
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(defvar melpa-not-include-packages
  '()
  "Don't install these Melpa packages")

;; Don't take Melpa versions of certain packages
(setq package-filter-function
      (lambda (package version archive)
        (and
         (not (memq package '(eieio)))
         (or (and (string-equal archive "melpa") (not (memq package melpa-not-include-packages)))
             (not (string-equal archive "melpa"))))))

;; un-comment below code if you prefer use all the package on melpa (unstable) without limitation
;; (setq package-filter-function nil)

;;------------------------------------------------------------------------------
;; Fire up package.el and ensure the following packages are installed.
;;------------------------------------------------------------------------------

(package-initialize)

(defcustom newbie/debug nil
  "Turn on to show debug log.")

;; make require several files easily.
(defun require-dir (dir)
  "Ask require on all files in dir."
  (let ((emacs-load-start-time (current-time)))
    (let ((count 0) (file-path))
      (dolist (path load-path)
        (when (string-equal dir (file-name-base path))
          (setq file-path path)
          (setq count (+ 1 count))))
      (if (= count 1)
          (dolist (file (directory-files file-path))
            (unless (or (file-directory-p (expand-file-name file))
                        (string-match "^[.]*#+" (file-name-base file))
                        (string-match "~+$" (expand-file-name file))
			(string-match "^flycheck_" (file-name-base file)))
              (require (intern (file-name-base file)))
              (when (and newbie/debug
                         (require 'time-date nil t))
                (message "Load File %s cost %s seconds."
                         file
                         (time-to-seconds (time-since emacs-load-start-time))))))
        (error "no one or more than one dir match, do nothing for require-dir %s." dir)))
    (when (and newbie/debug
               (require 'time-date nil t))
      (message "Load Dir %s cost %s seconds."
               dir
               (time-to-seconds (time-since emacs-load-start-time))))))

(provide 'init-elpa)
