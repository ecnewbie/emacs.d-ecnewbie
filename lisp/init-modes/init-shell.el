(require-package 'readline-complete)
(require 'readline-complete)

(setq explicit-shell-file-name "bash")
(setq explicit-bash-args '("-c" "export EMACS=; stty echo; bash"))
(setq comint-process-echoes t)

(require-package 'company)
(require 'company)
(push 'company-readline company-backends)
;;; don't try to trun off company-mode.
;;(add-hook 'rlc-no-readline-hook (lambda () (company-mode -1)))

;;; turn off yas-minor-mode.
(add-hook 'term-mode-hook (lambda()
                            (yas-minor-mode -1)))

(add-to-list 'auto-mode-alist '("\\.bash_profile\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bash_history\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.sh\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bash\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bashrc.local\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.zshrc\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bashrc\\'" . sh-mode))

(require 'multi-term)
(setq term-bind-key-alist
      '(
        ("C-c C-c" . term-interrupt-subjob)
        ("C-c C-j" . term-line-mode)
        ("C-c C-k" . term-char-mode)
        ("C-m" . term-send-return)
        ("C-y" . term-paste))
      )

(setq term-unbind-key-list
      '("C-z" "C-x" "C-c" "C-h" "C-y"
        "M-x"))

(add-hook 'term-mode-hook
          (lambda()
            (setq term-buffer-maximum-size 10000)
            (setq show-trailing-whitespace nil)))

(provide 'init-shell)
