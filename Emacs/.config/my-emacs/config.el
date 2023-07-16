(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.config/my-emacs/bonsai.png")
  (setq dashboard-banner-logo-title "Italo Amaya"))

(use-package swiper
  :ensure t
  :bind ("C-s" . 'swiper))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind
  ("M-x" . smex))

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("M-g" . magit-status))

(use-package projectile
  :ensure t
  :init
  (projectile-mode 1))

(use-package evil-leader
  :ensure t
  :config
  (evil-leader/set-leader " ")
  (global-evil-leader-mode))

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package key-chord
  :ensure t
  :config
  (setq key-chord-two-keys-delay 0.5)
  ;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  ;; (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
  :init
  (key-chord-mode 1))

(setq main-font "FiraCode Nerd Font-16"
      dropbox-directory "~/Personal/Dropbox/Bak"
      mac-option-modifier 'super
      mac-command-modifier 'meta
      ;; Backups
      backup-by-copying t ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq use-dialog-box nil)
(setq use-file-dialog nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode -1)
(scroll-bar-mode -1)
(global-subword-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

(use-package doom-themes
  :if window-system
  :ensure t
  :config
  (load-theme 'doom-badger t)
  (doom-themes-org-config)
  (doom-themes-visual-bell-config))

(add-to-list 'default-frame-alist
             '(font . main-font))

(let* ((variable-tuple
        (cond
         ((x-list-fonts "Monaco")         '(:font "Monaco"))
         ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
         ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
         ((x-list-fonts "Verdana")         '(:font "Verdana"))
         ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
         (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

(setq org-directory (concat dropbox-directory "/Org")
      org-ellipsis " ▾ "
      org-hide-emphasis-markers t
      )

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package lsp-mode
  :ensure t
  :hook
  ((python-mode . lsp)))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company
    :ensure t)

(use-package flycheck
  :ensure t)

(use-package emmet-mode
  :ensure t
  :init
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook  'emmet-mode))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))


