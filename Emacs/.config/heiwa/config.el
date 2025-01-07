(recentf-mode)
(add-to-list 'default-frame-alist '(undecorated . t))
(menu-bar-mode -1)
(tool-bar-mode -1)
(set-scroll-bar-mode nil)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

(setq display-line-numbers-type 'relative)
(setq scroll-margin 2)
(setq indent-tabs-mode nil)
(setq tab-width 4)

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@me.com")

(setq gnus-home-directory "/Users/italo/"
      config-dir (concat gnus-home-directory ".config/")
      drop-dir (concat gnus-home-directory "Personal/Dropbox/")
      org-directory (concat drop-dir "Bak/Org")
      bread-dir (concat config-dir "bread/")
      repos-dir (concat gnus-home-directory "Personal/Programming/Repos/")
      github-dir (concat repos-dir "github.com/")
      italoaa-dir (concat github-dir "italoaa/"))

(setq text-mode-ispell-word-completion nil)

(add-hook 'dired-mode-hook 'auto-revert-mode)

(set-face-attribute 'default nil :height 160)

(setq backup-by-copying t ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(add-to-list 'load-path (concat user-emacs-directory "nano-theme"))
(require 'nano-theme)

(nano-dark)

;;(load-theme 'spaceduck t)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

(add-to-list 'load-path (concat user-emacs-directory "evil"))
(setq evil-want-keybinding nil) ;; we dont want
(require 'evil)
(evil-mode 1)

;; evil collection dependencie
(add-to-list 'load-path (concat user-emacs-directory "annalist"))

;; evil collection
(add-to-list 'load-path (concat user-emacs-directory "evil-collection"))
(require 'evil-collection)
(evil-collection-init)

(unless (package-installed-p 'magit)
  (package-install 'magit))

(require 'magit)

(setq vertico-resize t)
(setq vertico-cycle t)
(require 'vertico)
(vertico-mode)

(require 'marginalia)
(marginalia-mode)

(add-to-list 'load-path (concat user-emacs-directory "consult"))
(require 'consult)

(setq register-preview-delay 0.5
      register-preview-function #'consult-register-format)

(advice-add #'register-preview :override #'consult-register-window)

(consult-customize
 consult-theme :preview-key '(:debounce 0.2 any)
 consult-ripgrep consult-git-grep consult-grep
 consult--source-bookmark consult--source-file-register
 consult--source-recent-file consult--source-project-recent-file
 ;; :preview-key "M-."
 :preview-key '(:debounce 0.4 any))

(setq consult-narrow-key "<") ;; "C-+"

(autoload 'projectile-project-root "projectile")
(setq consult-project-function (lambda (_) (projectile-project-root)))

(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))

(add-to-list 'org-link-frame-setup '(file . find-file))

(setq org-startup-indented t)
(setq org-edit-src-content-indentation 0)
(setq org-clock-sound (concat user-emacs-directory "bell.wav"))

(setq org-image-actual-width nil)

(evil-set-leader 'motion (kbd "SPC"))
(evil-define-key 'normal 'global (kbd "<leader> f s") 'save-buffer)
(evil-define-key 'normal 'global (kbd "<leader> j") 'next-buffer)
(evil-define-key 'normal 'global (kbd "<leader> k") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader> c") 'compile)
(evil-define-key 'normal 'global (kbd "<leader> f c") '(lambda () (interactive) (find-file "~/.config/bread/config.org")))
(evil-define-key 'normal 'global (kbd "<leader> f r") 'consult-recent-file)
(evil-define-key 'normal 'global (kbd "<leader> f b") 'consult-buffer)
(evil-define-key 'normal 'global (kbd "<leader> w c") 'evil-window-delete)
(evil-define-key 'normal 'global (kbd "<leader> w n") 'evil-window-new)
(evil-define-key 'normal 'global (kbd "<leader> w s") 'evil-window-split)
(evil-define-key 'normal 'global (kbd "<leader> w v") 'evil-window-vsplit)
(evil-define-key 'normal 'global (kbd "<leader> w h") 'evil-window-left)
(evil-define-key 'normal 'global (kbd "<leader> w j") 'evil-window-down)
(evil-define-key 'normal 'global (kbd "<leader> w k") 'evil-window-up)
(evil-define-key 'normal 'global (kbd "<leader> w l") 'evil-window-right)
(evil-define-key 'normal 'global (kbd "<leader> w w") 'evil-window-next)
(evil-define-key 'normal 'global (kbd "<leader> w H") 'buf-move-left)
(evil-define-key 'normal 'global (kbd "<leader> w J") 'buf-move-down)
(evil-define-key 'normal 'global (kbd "<leader> w K") 'buf-move-up)
(evil-define-key 'normal 'global (kbd "<leader> w L") 'buf-move-right)
(evil-define-key 'normal 'global (kbd "<leader> g g") 'magit)
