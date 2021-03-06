(require-package 'neotree)

(require 'neotree)
(defadvice delete-window (after kill-neotree-buffer activate)
  "Kill neotree buffer if it's window deleted."
  (when (and (neo-global--get-buffer)
             (get-buffer (neo-global--get-buffer)))
    (kill-buffer (neo-global--get-buffer))))

(provide 'init-neotree)
