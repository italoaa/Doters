(add-to-list 'load-path (concat user-emacs-directory "modules/"))

(require 'elpaca-setup)

(setq backup-by-copying t ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Expands to: (elpaca evil (use-package evil :demand t))
(use-package evil
  :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-vsplit-window-right t
        evil-split-window-below t)

  (setq evil-undo-system 'undo-redo)
  (evil-mode))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Themes
;; Spacegrey    Grey and contrast code
;; Miramare     greeny code and creamy text
;; FlatWhite    to highlight instead of changing the color of text
;; Gruvbox      to groove

;; Use elpaca to load the theme to ensure doom-themes is laoded
(elpaca nil (load-theme 'doom-spacegrey t))

(use-package smartparens
  :diminish smartparens-mode
  :defer 1
  :config
  ;; Load default smartparens rules for various languages
  (require 'smartparens-config)
  (setq sp-max-prefix-length 25)
  (setq sp-max-pair-length 4)
  (setq sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil)

  (with-eval-after-load 'evil
    (setq sp-show-pair-from-inside t)
    (setq sp-cancel-autoskip-on-backward-movement nil)
    (setq sp-pair-overlay-keymap (make-sparse-keymap)))

  (let ((unless-list '(sp-point-before-word-p
                       sp-point-after-word-p
                       sp-point-before-same-p)))
    (sp-pair "'"  nil :unless unless-list)
    (sp-pair "\"" nil :unless unless-list))

  ;; In lisps ( should open a new form if before another parenthesis
  (sp-local-pair sp-lisp-modes "(" ")" :unless '(:rem sp-point-before-same-p))

  ;; Don't do square-bracket space-expansion where it doesn't make sense to
  (sp-local-pair '(emacs-lisp-mode org-mode markdown-mode gfm-mode)
                 "[" nil :post-handlers '(:rem ("| " "SPC")))


  (dolist (brace '("(" "{" "["))
    (sp-pair brace nil
             :post-handlers '(("||\n[i]" "RET") ("| " "SPC"))
             ;; Don't autopair opening braces if before a word character or
             ;; other opening brace. The rationale: it interferes with manual
             ;; balancing of braces, and is odd form to have s-exps with no
             ;; whitespace in between, e.g. ()()(). Insert whitespace if
             ;; genuinely want to start a new form in the middle of a word.
             :unless '(sp-point-before-word-p sp-point-before-same-p)))
  (smartparens-global-mode t))

(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-enable-undo-in-region nil)
  (setq undo-tree-history-directory-alist '(("." . "~/.config/bread/undo")))
  (define-key evil-normal-state-map (kbd "u") 'undo-tree-undo)
  (define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)
  (global-undo-tree-mode 1))

(use-package projectile
  :config
  (projectile-mode 1))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(add-hook 'dired-mode-hook 'auto-revert-mode)

(with-eval-after-load 'dired
  (with-eval-after-load 'evil
    ;;(define-key dired-mode-map (kbd "M-p") 'peep-dired)
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)))

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook))

(use-package diminish)

(use-package magit)

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package dashboard
  :demand t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Fresh Baked Bread")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner (concat user-emacs-directory "bread-logo.png"))  ;; use custom image as banner
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents . 5)
                          (projects . 3)
                          ))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                            (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package olivetti
  :after org
  :init
  (setq olivetti-body-width 140)
  :hook (org-mode . olivetti-mode)
  :config
  (display-line-numbers-mode 0))

(use-package all-the-icons
  :demand t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package doom-modeline
  :demand t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon nil
        doom-modeline-major-mode-color-icon t
        doom-modeline-modal t)) ;; adds folder icon next to persp name

;; How to display icons correctly?

;; nerd-icons are necessary. Then run M-x nerd-icons-install-fonts to install the resource fonts. On Windows, the fonts should be installed manually. nerd-icons supports both GUI and TUI.

(use-package rainbow-mode
  :diminish
  :hook org-mode prog-mode)

(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-allow-imprecise-window-fit nil
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil
        which-key-separator " → " ))

(use-package general
  :config
  (general-evil-setup)

  ;; set up 'SPC' as the global leader key
  (general-create-definer flour/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode

  (flour/leader-keys
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "." '(find-file :wk "Find file")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
    "f r" '(counsel-recentf :wk "Find recent files")
    "j" '(next-buffer :wk "next buffer")
    "k" '(previous-buffer :wk "next buffer")
    "TAB TAB" '(comment-line :wk "Comment lines"))

  (flour/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-this-buffer :wk "Kill this buffer")
    "b K" '(kill-some-buffers :wk "Kill multiple buffers")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file"))

  (flour/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current")
    "d n" '(neotree-dir :wk "Open directory in neotree")
    "d p" '(peep-dired :wk "Peep-dired"))

  (flour/leader-keys
    "e" '(:ignore t :wk "Eshell/Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e h" '(counsel-esh-history :which-key "Eshell history")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    "e s" '(eshell :which-key "Eshell"))

 (flour/leader-keys
    "h" '(:ignore t :wk "Help")
    "h a" '(counsel-apropos :wk "Apropos")
    "h b" '(describe-bindings :wk "Describe bindings")
    "h c" '(describe-char :wk "Describe character under cursor")
    "h d" '(:ignore t :wk "Emacs documentation")
    "h d a" '(about-emacs :wk "About Emacs")
    "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
    "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
    "h d m" '(info-emacs-manual :wk "The Emacs manual")
    "h d n" '(view-emacs-news :wk "View Emacs news")
    "h d o" '(describe-distribution :wk "How to obtain Emacs")
    "h d p" '(view-emacs-problems :wk "View Emacs problems")
    "h d t" '(view-emacs-todo :wk "View Emacs todo")
    "h d w" '(describe-no-warranty :wk "Describe no warranty")
    "h e" '(view-echo-area-messages :wk "View echo area messages")
    "h f" '(describe-function :wk "Describe function")
    "h F" '(describe-face :wk "Describe face")
    "h g" '(describe-gnu-project :wk "Describe GNU Project")
    "h i" '(info :wk "Info")
    "h I" '(describe-input-method :wk "Describe input method")
    "h k" '(describe-key :wk "Describe key")
    "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
    "h L" '(describe-language-environment :wk "Describe language environment")
    "h m" '(describe-mode :wk "Describe mode")
    "h r" '(:ignore t :wk "Reload")
    "h r r" '((lambda () (interactive)
                (load-file "~/.config/emacs/init.el")
                (ignore (elpaca-process-queues)))
              :wk "Reload emacs config")
    "h t" '(load-theme :wk "Load theme")
    "h v" '(describe-variable :wk "Describe variable")
    "h w" '(where-is :wk "Prints keybinding for command if set")
    "h x" '(describe-command :wk "Display full documentation for command"))

  (flour/leader-keys
    "m" '(:ignore t :wk "Org")
    "m a" '(org-agenda :wk "Org agenda")
    "m e" '(org-export-dispatch :wk "Org export dispatch")
    "m i" '(org-toggle-item :wk "Org toggle item")
    "m t" '(org-todo :wk "Org todo")
    "m B" '(org-babel-tangle :wk "Org babel tangle")
    "m T" '(org-todo-list :wk "Org todo list"))

  (flour/leader-keys
    "m b" '(:ignore t :wk "Tables")
    "m b -" '(org-table-insert-hline :wk "Insert hline in table"))

  (flour/leader-keys
    "m d" '(:ignore t :wk "Date/deadline")
    "m d t" '(org-time-stamp :wk "Org time stamp"))

  (flour/leader-keys
    "p" '(projectile-command-map :wk "Projectile"))

  (flour/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t f" '(flycheck-mode :wk "Toggle flycheck")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t r" '(rainbow-mode :wk "Toggle rainbow mode")
    "t t" '(visual-line-mode :wk "Toggle truncated lines")
    "t v" '(vterm-toggle :wk "Toggle vterm")
    "t i" '(org-toggle-inline-images :wk "toggle inline images"))

  (flour/leader-keys
   "f" '(:ignore t :wk "File")
   "f s" #'save-buffer)

  (flour/leader-keys
    "n" '(:ignore t :wk "Roam notes")
    "n i" '(org-roam-node-insert :wk "Insert node at point")
    "n f" '(org-roam-node-find :wk "Find node"))

  (flour/leader-keys
    "w" '(:ignore t :wk "Windows")
    ;; Window splits
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-split :wk "Horizontal split window")
    "w v" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Goto next window")
    ;; Move Windows
    "w H" '(buf-move-left :wk "Buffer move left")
    "w J" '(buf-move-down :wk "Buffer move down")
    "w K" '(buf-move-up :wk "Buffer move up")
    "w L" '(buf-move-right :wk "Buffer move right"))

  (flour/leader-keys
    "g" '(:ignore t :wk "Git")
    "g g" '(magit :wk "Magit"))

;;   (general-define-key
;;    :state '(normal vis)
;;    "u" '(nil)
;;    "C-r" 'undo-tree-redo)
)

;; (evil-define-key 'normal dired-mode-map (kbd "C-u") #'evil-scroll-up)

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)

  ;; Auto complete with C-SPC
  ;; (evil-define-key 'insert dired-mode-map (kbd "C-SPC") 'company-complete-common)

  (global-company-mode t))

(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package counsel
  :after ivy
  :diminish
  :config (counsel-mode))

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode))

(elpaca nil (global-set-key "\C-s" 'swiper)) ;; Use swiper

(use-package all-the-icons-ivy-rich
  :demand t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :demand t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package ivy-prescient
  :config
  (ivy-prescient-mode))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (rust-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)



(use-package yasnippet
  :demand t
  :config
  (yas-global-mode 1)
  (yas-minor-mode-on))
(use-package yasnippet-snippets
  :demand t)

(use-package flycheck
  :demand t
  :defer t
  :diminish
  :init (global-flycheck-mode))

;; Correct indentation ;)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(setq display-line-numbers-type 'relative)
(setq scroll-margin 8)

;; I prefer cmd key for meta
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(defvar Dropbox-dir "~/Personal/Dropbox"
  "Path the the directory of dropbox")

(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@icloud.com"
      org-directory (concat Dropbox-dir "/Bak/Org"))

(set-face-attribute 'default nil
  :font "FiraCode Nerd Font"
  :height 160
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "FiraCode Nerd Font"
  :height 160
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "FiraCode Nerd Font"
  :height 160
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

;; Needed if using emacsclient. Otherwise, your fonts will be smaller than expected.
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-16"))
;; changes certain keywords to symbols, such as lamda!
(setq global-prettify-symbols-mode t)

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

(setq org-hide-emphasis-markers t)

;; Unbind RET for going to links
;; (evil-define-key 'normal evil-motion-mode-map (kbd "RET") nil)
(setq org-return-follows-link t)

;; Opens file links in the same window
(add-to-list 'org-link-frame-setup '(file . find-file))

(eval-after-load 'org-indent '(diminish 'org-indent-mode))

(electric-indent-mode -1)
(setq org-edit-src-content-indentation 0)

(add-hook 'org-mode-hook 'org-indent-mode)

(require 'org-tempo)

(use-package org-roam
  :config
  (org-roam-db-autosync-mode 1))
(setq org-roam-directory (concat org-directory "/roam/"))
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-direction)
               (direction . right)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))

(setq org-roam-capture-templates '(
                                   ("d" "default" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :%^{Select Tag|Physics|Math|AppliedMaths|CompSci|Programming}:\n")
                                    :unnarrowed t)
                                   ("u" "uni" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :University:%^{Select Tag|Physics|Math|AppliedMaths|CompSci|Programming}:%^{Select Uni Course|ComputerProcessors|DataBases|DiscreteMaths|}:\n")
                                    :unnarrowed t)
                                   ("c" "CompSci" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :CompSci:%^{Select Further CompSci Topic|CyberSecurity}:\n")
                                    :unnarrowed t)
                                   ("e" "Comptia Exam note" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :CompSci:CyberSecurity:sec+:\n")
                                    :unnarrowed t)
                                   ("r" "ref" plain "%?" :target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n")
                                    :unarrowed t)
                                   ("n" "ref + noter" plain "%?":target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n\n\n* ${title}\n:PROPERTIES:\n:Custom_ID: ${citekey}\n:URL: ${url}\n:AUTHOR: ${author-or-editor}\n:NOTER_DOCUMENT: ${file}\n:END:")
                                    :unarrowed t)
                                   ))

(use-package evil-org
  :demand t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-download
    :after org
    :defer nil
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "files")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y%m%d-%H%M%S_")
    (org-download-image-org-width 300)
    (org-download-screenshot-method "/usr/local/bin/pngpaste %s")
    :config
    (require 'org-download)
    (org-download-enable))

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t        ;; A default setting that needs to be    t for org-appear
        org-appear-autoemphasis t        ;; Enable org-appear on emphasis (bold, italics, etc)
        org-appear-autolinks nil        ;; Don't enable on links
        org-appear-autosubmarkers t))    ;; Enable on subscript and superscript

(use-package org-bullets
    :hook (org-mode . org-bullets-mode)
    :custom
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    (org-bullets-bullet-list '("◉" "○" "■" "◆" "▲" "▶")))

(use-package rust-mode
  :config
  (setq rust-format-on-save t
	rust-rustfmt-bin "/Users/italo/.cargo/bin/rustfmt"
	rust-cargo-bin "/Users/italo/.cargo/bin/cargo"))

(add-hook 'rust-mode-hook 'lsp-deferred) ;; Load lsp when in a rust buffer

(use-package tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)

(elpaca (ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold"))
(elpaca nil (global-ts-fold-mode 1))

(use-package lsp-pyright
  :demand t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package emmet-mode)


