;; @see http://emacs-fu.blogspot.com/2011/08/customizing-mode-line.html
;; But I need global-mode-string,
;; @see http://www.delorie.com/gnu/docs/elisp-manual-21/elisp_360.html
;; use setq-default to set it for /all/ modes

;; set frame title.
(setq-default frame-title-format
              '(buffer-file-name
                "%f"
                (dired-directory dired-directory "%b")))

(setq-default mode-line-format
              (list
               ;; the buffer name; the file name as a tool tip
               '(:eval (propertize "%b " 'face (if (window-system)
                                                   'font-lock-keyword-face
                                                 nil)
                                   'help-echo (buffer-file-name)))

               ;; line and column
               "(" ;; '%02' to set to 2 chars at least; prevents flickering
               (propertize "%02l" 'face nil ) ","
               (propertize "%02c" 'face nil )
               ") "

               ;; relative position, size of file
               "["
               (propertize "%p" 'face nil) ;; % above top
               "/"
               (propertize "%I" 'face nil) ;; size
               "] "

               ;; the current major mode for the buffer.
               "["

               '(:eval (propertize "%m" 'face nil
                                   'help-echo buffer-file-coding-system))
               "] "


               "[" ;; insert vs overwrite mode, input-method in a tooltip
               '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
                                   'face (if (window-system)
                                             'font-lock-string-face
                                           nil)
                                   'help-echo (concat "Buffer is in "
                                                      (if overwrite-mode "overwrite" "insert") " mode")))

               ;; was this buffer modified since the last save?
               '(:eval (when (buffer-modified-p)
                         (concat ","  (propertize "Mod"
                                                  'face (if (window-system)
                                                            'font-lock-warning-face
                                                          nil)
                                                  'help-echo "Buffer has been modified"))))

               ;; is this buffer read-only?
               '(:eval (when buffer-read-only
                         (concat ","  (propertize "RO"
                                                  'face (if (window-system)
                                                            'font-lock-type-face
                                                          nil)
                                                  'help-echo "Buffer is read-only"))))
               "] "

               ;; global-mode-string, org-timer-set-timer in org-mode need this
               " ["
               (propertize "%M" 'face nil)
               "] ---"

               minor-mode-alist  ;; list of minor modes

               ;;"%-" ;; fill with '-'
               ))

(provide 'init-modeline)
