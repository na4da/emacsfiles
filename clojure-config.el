;; Clojure
(use-package clojure-mode
  :defer t
  :init
  (add-hook 'clojure-mode-hook 'yas-minor-mode)
  (add-hook 'clojure-mode-hook 'subword-mode))

(use-package cider
  :defer t
  :init
  (add-hook 'cider-mode-hook 'company-mode)
  (add-hook 'cider-mode-hook 'eldoc-mode)
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (add-hook 'cider-repl-mode-hook 'eldoc-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        cider-overlays-use-font-lock t
        nrepl-use-ssh-fallback-for-remote-hosts t)
  (cider-repl-toggle-pretty-printing))

(defun cider-connect-from-local-file ()
  (interactive)
  (cider-version)
  (let ((vhost (shell-command-to-string "vagrant ssh -c 'hostname | cut -d \" \" -f 2 | tr -d \"\n\"'"))
        (vport (nth 1 (car (cider-locate-running-nrepl-ports)))))
    (cider-connect (thread-first nil
                     (plist-put :host vhost)
                     (plist-put :port vport)))
    (cider-load-all-project-ns)))
(global-set-key (kbd "C-c M-v") 'cider-connect-from-local-file)
