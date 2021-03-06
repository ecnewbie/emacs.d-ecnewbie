(when (executable-find "fcitx")
  (require-package 'fcitx)
  (require 'fcitx)
  (fcitx-default-setup))

(require-package 'chinese-pyim)
(require 'chinese-pyim)
(require-package 'chinese-pyim-greatdict)
(require 'chinese-pyim-greatdict)
(chinese-pyim-greatdict-enable)

(setq default-input-method "chinese-pyim")

(require-package 'pangu-spacing)
(require 'pangu-spacing)
;; For better performance.
;; (global-pangu-spacing-mode 1)

;;;FIXME: org table
;; (add-hook 'org-mode-hook
;;           '(lambda ()
;;              (set-face-attribute 'org-table nil :font "WenQuanYi Zen Hei Mono-12:weight=normal")
;;              (setq face-font-rescale-alist (list (cons "DejaVu Sans Mono" 1.2)))
;;              (print (face-attribute 'org-table ':font))))

(provide 'init-chinese)
