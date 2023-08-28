(load "~/.emacs.d/sanemacs.el" nil t)

;; Enable fatfingeredness
(global-unset-key (kbd "C-x C-c"))

;; Evil mode

(use-package evil
  :ensure t
  :init
  (setq evil-undo-system 'undo-tree)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :ensure t
  :config
  (global-evil-surround-mode t))

(use-package evil-visualstar
  :after evil
  :ensure t
  :config
  (global-evil-visualstar-mode t))

(electric-pair-mode t)

;; Projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode t)
  :bind (:map projectile-mode-map ("C-c p" . projectile-command-map)))

;; Languages
(use-package pyvenv)

(use-package eglot
  :ensure nil
  :hook (python-mode . eglot-ensure)
  :bind (:map eglot-mode-map ("C-c e r" . eglot-rename)))

;; Prompts

(use-package which-key
  :config
  (which-key-mode t))

(use-package ido
  :ensure nil
  :init
  (setq ido-enable-flex-matching t)
  :config
  (ido-mode t)
  (global-set-key (kbd "M-x") (lambda ()
				(interactive)
				(call-interactively
				 (intern
				  (ido-completing-read
				   "M-x "
				   (all-completions "" obarray 'commandp)))))))


;; Visuals
(use-package inkpot-theme
  :init
  (setq inkpot-theme-use-box t)
  (setq inkpot-theme-use-black-background t)
  :config
  (load-theme 'inkpot))

(set-default 'truncate-lines t)

(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

(add-hook 'compilation-mode 'auto-revert-tail-mode)
