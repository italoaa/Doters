;; Remove the tilte bar
(add-to-list 'load-path (concat user-emacs-directory "modules/"))
(add-to-list 'load-path (concat user-emacs-directory "modules/mu4e/"))
(add-to-list 'load-path (concat user-emacs-directory "modules/nano-emacs/"))

;; Settings for nano
(setq nano-enabled t)
;; Use an if statement if nano is enabled
;;(require 'nano-modeline)
(require 'nano-colors)
;;(require 'nano-layout)
(require 'nano-command)
(require 'nano-faces)
;;(require 'nano-theme)
;; (require 'nano-hl-block)
(if nano-enabled
    (progn
      (setq nano-font-size 15)

      (require 'nano-faces)
      ;; (require 'nano-theme)
      ;; (require 'nano-theme-dark)
      ;; (require 'nano-theme-light)

      ;; (nano-theme-set-light)
      ;; (call-interactively 'nano-refresh-theme)

      ;; End the config loading with the splash screen
      ;; (require 'nano-splash)
      ;; (require 'nano-agenda)
      ;; (require 'nano-minibuffer)
      (set-scroll-bar-mode nil)
      )
  )

(require 'elpaca-setup)

(require 'secret)

(setq backup-by-copying t ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq initial-scratch-message "\
;; Don't Complain!

")

(recentf-mode)
(add-to-list 'default-frame-alist '(undecorated . t))
;;(elpaca nil (setq mu4e-mu-version "1.10.8"))

;; Correct indentation ;)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(menu-bar-mode t)
(tool-bar-mode -1)
(set-scroll-bar-mode nil)
(blink-cursor-mode -1)

;; (global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(setq display-line-numbers-type 'relative)
(setq scroll-margin 2)
(setq indent-tabs-mode nil)
(setq tab-width 4)


;; font
(set-face-attribute 'default nil :font "Aporetic Sans Mono")
(set-face-attribute 'default nil :height 165) ; For 12pt font

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize t
      frame-title-format '("%b")
      ring-bell-function 'ignore
      use-dialog-box t ; only for mouse events, which I seldom use
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name ; read the docstring
      inhibit-startup-buffer-menu t)


;; I prefer cmd key for meta
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@me.com")

;; Common directories
(setq gnus-home-directory "/Users/italo/"
      gnus-cache-directory "/Users/italo/.cache/emacs"
      gnus-cache-active-file "/Users/italo/.cache/emacs/active"
      config-dir (concat gnus-home-directory ".config/")
      downloads-dir (concat gnus-home-directory "Downloads/")
      drop-dir (concat gnus-home-directory "Personal/Dropbox/")
      org-directory (concat drop-dir "Bak/Org")
      bread-dir (concat config-dir "bread/")
      repos-dir (concat gnus-home-directory "Personal/Programming/Repos/")
      github-dir (concat repos-dir "github.com/")
      italoaa-dir (concat github-dir "italoaa/"))


(defun kill-all-except-dashboard-and-essential ()
  "Kill all buffers except the dashboard, *scratch*, and *Messages*, prompting to save unsaved buffers with y or n."
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      ;; Check if the buffer is neither the dashboard, *scratch*, nor *Messages*.
      (when (and (not (eq major-mode 'dashboard-mode))
                 (not (equal (buffer-name) "*scratch*"))
                 (not (equal (buffer-name) "*Messages*")))
        ;; If the buffer is modified, prompt to save it using y-or-n-p.
        (when (and (buffer-modified-p)
                   (buffer-file-name))
          (if (y-or-n-p (format "Save buffer %s before killing? (y/n) " (buffer-name)))
              (save-buffer)
            (set-buffer-modified-p nil)))
        (kill-buffer buffer)))))


;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
;; try `cape-dict'.
(setq text-mode-ispell-word-completion nil)

;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
;; mode.  Corfu commands are hidden, since they are not used via M-x. This
;; setting is useful beyond Corfu.
(setq read-extended-command-predicate #'command-completion-default-include-p)

(use-package spacious-padding
  :ensure t
  :if (display-graphic-p)
  :hook (after-init . spacious-padding-mode)
  :bind ("<f8>" . spacious-padding-mode)
  :init
  ;; These are the defaults, but I keep it here for visiibility.
  (setq spacious-padding-widths
        '( :internal-border-width 30
           :header-line-width 4
           :mode-line-width 6
           :tab-width 4
           :right-divider-width 30
           :scroll-bar-width 8
           :left-fringe-width 20
           :right-fringe-width 20))

  ;; Read the doc string of `spacious-padding-subtle-mode-line' as
  ;; it is very flexible.
  (setq spacious-padding-subtle-mode-line
        '( :mode-line-active spacious-padding-subtle-mode-line-active
           :mode-line-inactive spacious-padding-subtle-mode-line-inactive))
  )


;;(elpaca nil (spacious-padding-mode))

(use-package perspective
  :custom
  (persp-suppress-no-prefix-key-warning t)
  :init
  (persp-mode))
(force-mode-line-update)

;; so japanese characters dont lag

(set-fontset-font "fontset-default" 'big5 "Noto Sans Mono CJK TC")

(require 'fish)


(setq fish-update-period 0.4) ;; Time between flaps (default 0.2 seconds)
(setq fish-bar-length 20) ;; Width of swimming area (default 32)

(defun my-modeline--vc-branch ()
  "Get the current Git branch for the mode line."
  (when vc-mode
    (let ((branch (magit-get-current-branch)))
      (if branch
          (format "  %s " (car (split-string branch "-g" t))) ;; Extract branch name
        ""))))

(defvar-local my-modeline-vc-branch
    '(:eval
      (when (mode-line-window-selected-p)
	(propertize (my-modeline--vc-branch) 'face 'font-lock-comment-face)))
  "Mode line construct to display the current Git branch.")

(put 'my-modeline-vc-branch 'risky-local-variable t)

;; Function to get current perspective name
;; (defun my-modeline--persp-name ()
  ;; "Get current perspective name for the mode line."
  ;; (when (bound-and-true-p persp-mode)
    ;; (let ((name (persp-current-name)))
      ;; (if name
          ;; (format " [%s] " name)
        ;; " default "))))

;; Perspective modeline variable
;; (defvar-local my-modeline-persp-name
    ;; '(:eval
      ;; (when (mode-line-window-selected-p)
	;; (propertize (my-modeline--persp-name) 'face 'elpaca-busy)))
  ;; "Mode line construct to display the perspective name.")

;; (put 'my-modeline-persp-name 'risky-local-variable t)

(fish-start-timer)

;; Updated modeline format with perspective name
(setq-default mode-line-format
	      '("%e"
                my-modeline-buffer-name
		"  "
                my-modeline-major-mode
		" "
		my-modeline-vc-branch
                " "
                my-modeline-fish
                ))

;; Rest of your existing code
(defcustom my-modeline-max-buffer-name-length 30
  "Maximum length of buffer name to display in modeline before truncating."
  :type 'integer
  :group 'my-modeline)

(defcustom my-modeline-buffer-name-ellipsis "..."
  "String to show at the end of truncated buffer names."
  :type 'string
  :group 'my-modeline)

(defun my-modeline--buffer-name ()
  "Return `buffer-name` formatted for modeline with truncation if needed."
  (let* ((name (buffer-name))
         (ellipsis-length (length my-modeline-buffer-name-ellipsis))
         (max-effective-length (- my-modeline-max-buffer-name-length ellipsis-length))
         (truncated-name (if (> (length name) my-modeline-max-buffer-name-length)
                             (concat 
			      (substring name 0 max-effective-length)
			      my-modeline-buffer-name-ellipsis)
                           name)))
    (format " %s " truncated-name)))

(defvar-local my-modeline-buffer-name
  '(:eval
    (propertize (my-modeline--buffer-name)
                'face (if (mode-line-window-selected-p)
                          'elpaca-busy  ;; Face when window is selected
                        'shadow)))  ;; Face when window is not selected
    "Mode line construct to display the buffer name with conditional formatting.")

(put 'my-modeline-buffer-name 'risky-local-variable t)

(defun my-modeline--major-mode-name ()
  "Return capitalized `major-mode' as a string."
  (capitalize (symbol-name major-mode)))

fish-mode-line-string
(defvar-local my-modeline-fish
    '(:eval
      (when (mode-line-window-selected-p)
	(propertize fish-mode-line-string 'face 'default))
      )
  "Mode line construct to display the fish")
(put 'my-modeline-fish 'risky-local-variable t)

(defvar-local my-modeline-major-mode
    '(:eval
      (list
       (propertize "雨" 'face 'shadow)
       " "
      (when (mode-line-window-selected-p)
       (propertize (my-modeline--major-mode-name) 'face 'bold))
      )
      )
  "Mode line construct to display the major mode.")

(put 'my-modeline-major-mode 'risky-local-variable t)

;; Define the fallback function if not available
(unless (fboundp 'mode-line-window-selected-p)
  (defun mode-line-window-selected-p ()
    "Return non-nil if we're updating the mode line for the selected window.
  This function is meant to be called in `:eval' mode line
  constructs to allow altering the look of the mode line depending
  on whether the mode line belongs to the currently selected window
  or not."
    (let ((window (selected-window)))
      (or (eq window (old-selected-window))
	  (and (minibuffer-window-active-p (minibuffer-window))
	       (with-selected-window (minibuffer-window)
		 (eq window (minibuffer-selected-window))))))))

(setq evil-symbol-word-search t)

(add-to-list 'display-buffer-alist
	     '("\\*Compilation\\*"
	       (display-buffer-in-side-window)
	       (side . right)
	       (window-width . 80)))

(add-to-list 'display-buffer-alist
	     '("\\*Org Src.*\\*"
	       (display-buffer-in-side-window)
	       (side . right)
	       (window-width . 80)))

;; make a function to open a new scratch buffer in org mode
(defun new-scratch-org-buffer ()
  "Create a new scratch buffer in org mode"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch-org*"))
  (org-mode))

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

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

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
  (doom-themes-org-config)

  (if (not nano-enabled)
      (load-theme 'doom-spacegrey t)
    (set-face-attribute 'default nil :height 150) ; For 12pt font
    )
  )

;; Themes
;; Spacegrey    Grey and contrast code
;; Miramare     greeny code and creamy text
;; FlatWhite    to highlight instead of changing the color of text
;; Gruvbox      to groove

;; Use elpaca to load the theme to ensure doom-themes is laoded

(use-package auto-dark
  :init (auto-dark-mode)
  :custom
  (auto-dark-themes '((doom-spacegrey) (doom-flatwhite)))
  )

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

(use-package ag)
(use-package rg)

(use-package dired-open
  :config
  (setq dired-open-extensions '(("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(add-hook 'dired-mode-hook 'auto-revert-mode)

(setq insert-directory-program "ls")  ;; Use exa instead of ls
(setq dired-listing-switches "-lah")



(with-eval-after-load 'dired
  (with-eval-after-load 'evil
    ;;(define-key dired-mode-map (kbd "M-p") 'peep-dired)
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)))

(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook))

(use-package diminish)

(use-package magit)
(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package vterm
  :init
  (setq vterm-shell "/usr/local/bin/fish"))

(use-package exec-path-from-shell
 :custom
 (shell-file-name "/usr/local/bin/fish" "This is necessary because some Emacs install overwrite this variable")
 (exec-path-from-shell-variables '("PATH" "MANPATH" "PKG_CONFIG_PATH") "This adds PKG_CONFIG_PATH to the list of variables to grab. I prefer to set the list explicitly so I know exactly what is getting pulled in.")
 :init
 (if (string-equal system-type "darwin")
    (exec-path-from-shell-initialize)))

(setq tramp-default-method "ssh")

;; Add hook to use hs mode

(use-package pdf-tools
  :config
  ;; Disable docview mode since pdf-tools is better
  (pdf-tools-install)
  (setq auto-mode-alist (delete '("\\.pdf\\'" . doc-view-mode) auto-mode-alist))
  (require 'display-line-numbers)
  (defun display-line-numbers--turn-on ()
    "Turn on `display-line-numbers-mode'."
    (unless (or (minibufferp) (eq major-mode 'pdf-view-mode))
      (display-line-numbers-mode)))
  )

(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))
(transparency 96)

(use-package all-the-icons
  :demand t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package olivetti)

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

(use-package svg-tag-mode)

(use-package yeetube
 :ensure (:host github :repo "https://git.thanosapollo.org/yeetube")
 :config
 )

(use-package dirvish)

;;(elpaca nil (define-key evil-insert-state-map (kbd "ESC ESC ESC") 'evil-force-normal-state))
(global-set-key (kbd "C-<escape>") 'evil-collection-corfu-quit-and-escape)

(use-package general
  :config
  (general-evil-setup)

  ;; THis is to go up and down in wrapped lines
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-global-set-key 'insert (kbd " ") 'org-roam-node-insert)

  ;; Popper
  (evil-global-set-key 'normal (kbd "C-t") 'popper-toggle)
  (evil-global-set-key 'insert (kbd "C-t") 'popper-toggle)
  (evil-global-set-key 'normal (kbd "C-<tab>") 'popper-cycle)

  ;; Auto complete with C-SPC
  ;; (evil-global-set-key 'insert (kbd "C-SPC") 'company-complete-common)
  (evil-global-set-key 'normal "\C-s" 'consult-line)
  ;;(elpaca nil (define-key evil-insert-state-map (kbd " ") 'org-roam-node-insert))

  (defun rk/copilot-tab ()
    "Tab command that will complet with copilot if a completion is
available. Otherwise will try company, yasnippet or normal
tab-indent."
    (interactive)
    (or (copilot-accept-completion)
        (indent-for-tab-command)))

  (evil-define-key 'insert copilot-mode-map (kbd "ç") 'copilot-accept-completion)
  (evil-define-key 'insert copilot-mode-map (kbd "<tab>") #'rk/copilot-tab)

  (general-def mu4e-headers-mode-map
    "r" '(mu4e-view-mark-for-read :wk "Mark as read"))

  ;; set up 'RET' as a secondary menu
  (general-create-definer flour/ret-keys
    :states '(normal)
    :keymaps 'org-mode-map
    :prefix "RET"
    :glbal-prefix "C-RET")

  (flour/ret-keys
    "l" '(org-latex-preview :wk "preview latex fragments")
    "s" '(jinx-correct :wk "flyspell Correct word")
    "RET" '(org-open-at-point :wk "org open at point")
    "i" '(org-toggle-inline-images :wk "Show inline images")
    "x" '(org-babel-execute-src-block :wk "Execute a src code block")
    )

  (general-create-definer flour/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "∫") ;; access leader in insert mode

  (flour/leader-keys
    "SPC" '(find-file :wk "Projectile find file")
    "RET" '(evil-ret :wk "Evil ret")
    "." '(find-file :wk "Find file")
    "j" '(next-buffer :wk "next buffer")
    "k" '(previous-buffer :wk "next buffer")
    "c" '(compile :wk "compile")
    "x" '(org-capture :wk "Org capture")
    "s" '(ff-find-other-file :wk "next buffer")
    "/" '(comment-line :wk "Comment lines"))

  (flour/leader-keys
    "TAB" '(:ignore t :wk "Perspectives")
    "TAB b" '(persp-ivy-switch-buffer :wk "Switch buffer")
    "TAB l" '(persp-switch :wk "Switch Perspective")
    "TAB k" '(persp-switch :wk "Kill Perspective")
    )

  (flour/leader-keys
    "f R" '((lambda () (interactive) (find-file italoaa-dir)) :wk "Find Project")
    "f C" '((lambda () (interactive) (find-file config-dir)) :wk "Find Config")
    "f D" '((lambda () (interactive) (find-file downloads-dir)) :wk "Find Config")
    "f c" '((lambda () (interactive) (find-file "~/.config/bread/config.org")) :wk "Edit emacs config")
    "f r" '(consult-recent-file :wk "Find recent files")
    "f b" '(consult-buffer :wk "Find buffer")
    )

  (flour/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-buffer :wk "Kill this buffer")
    "b K" '(kill-all-except-dashboard-and-essential :wk "Kill All except escential")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b j" '(bookmark-jump :wk "Bookmark Jump")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file"))

  (flour/leader-keys
    "y" '(:ignore t :wk "Yeetube")
    "y RET" '(yeetube-play :wk "Play video")
    "y d" '(yeetube-download-video :wk "Download video")
    "y b" '(yeetube-play-saved-video :wk "Play saved video")
    "y B" '(yeetube-save-video :wk "Save video")
    "y x" '(yeetube-remove-saved-video :wk "Remove saved video")
    "y /" '(yeetube-search :wk "Search")
    "y 0" '(yeetube-toggle-video :wk "Toggle video"))

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
    "M" '(:ignore t :wk "Modes")
    "M o" '(org-mode t :wk "Org mode")
    "M p" '(python-ts-mode t :wk "Python mode")
    "M e" '(emacs-lisp-mode t :wk "Elisp mode")
    "M c" '(c-ts-mode t :wk "Elisp mode")
    "M C" '(c++-ts-mode t :wk "Elisp mode")
    )
  (flour/leader-keys
    "m" '(:ignore t :wk "Org")
    "m a" '(org-agenda :wk "Org agenda")
    "m e" '(org-export-dispatch :wk "Org export dispatch")
    "m i" '(org-toggle-item :wk "Org toggle item")
    "m t" '(org-todo :wk "Org todo")
    "m B" '(org-babel-tangle :wk "Org babel tangle")
    "m T" '(org-todo-list :wk "Org todo list")
    "m c" '(:ignore t :wk "Org Clock")
    "m c i" '(org-clock-in :wk "Org clock in")
    "m c o" '(org-clock-out :wk "Org clock out")
    "m c g" '(org-clock-goto :wk "Org clock goto")
    "m c r" '(org-clock-report :wk "Org clock report")
    "m b" '(:ignore t :wk "Tables")
    "m b -" '(org-table-insert-hline :wk "Insert hline in table")
    "m d" '(:ignore t :wk "Date/deadline")
    "m d t" '(org-time-stamp :wk "Org time stamp"))

  (flour/leader-keys
    "p" '(projectile-command-map :wk "Projectile"))

  (flour/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t f" '(jinx-mode :wk "Toggle flycheck")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t r" '(rainbow-mode :wk "Toggle rainbow mode")
    "t u" '(org-tidy-untidy-buffer :wk "Untify current buffer until save")
    "t s" '(spacious-padding-mode :wk "Toggle spacious padding mode")
    "t t" '(org-sidebar-tree-toggle :wk "Toggle the org tree")
    "t i" '(org-toggle-inline-images :wk "toggle inline images"))

  (flour/leader-keys
    "f" '(:ignore t :wk "File")
    "f s" #'save-buffer)

  (flour/leader-keys
    "n" '(:ignore t :wk "Roam notes")
    "n i" '(org-roam-node-insert :wk "Insert node at point")
    "n u" '(org-roam-ui-open :wk "Insert node at point")
    "n p" '(org-download-clipboard :wk "Paste Image from clipboard")
    "n a" '(org-roam-alias-add :wk "Add an alias")
    "n t" '(org-roam-tag-add :wk "Add a tag")
    "n T" '(org-roam-tag-remove :wk "Remove a tag")
    "n A" '(org-roam-alias-remove :wk "Remove an alias")
    "n s" '(org-narrow-to-subtree :wk "Narrow focus to subtree")
    "n w" '(widen :wk "Widen focus")
    "n f" '(org-roam-node-find :wk "Find node"))

  (flour/leader-keys
    "l" '(:ignore t :wk "Windows")
    ;; Window splits
    "l r" '(lsp-rename :wk "Lsp Rename")
    "l R" '(lsp-find-references :wk "Lsp Find references")
    "l d" '(lsp-find-definition :wk "Lsp Find definitioin")
    "l D" '(lsp-find-declaration :wk "Lsp Find declaration")
    )

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
    "w H" '(windmove-swap-states-left :wk "Buffer move left")
    "w J" '(windmove-swap-states-down :wk "Buffer move down")
    "w K" '(windmove-swap-states-up :wk "Buffer move up")
    "w L" '(windmove-swap-states-right :wk "Buffer move right"))

  (flour/leader-keys
    "g" '(:ignore t :wk "Git")
    "g g" '(magit :wk "Magit"))

  ;;   (general-define-key
  ;;    :state '(normal vis)
  ;;    "u" '(nil)
  ;;    "C-r" 'undo-tree-redo)

  (general-define-key)
  )

;; (evil-define-key 'normal dired-mode-map (kbd "C-u") #'evil-scroll-up)

(use-package jinx
  :hook (emacs-startup . global-jinx-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; (add-to-list 'completion-at-point-functions #'cape-tex)
  ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
  ;; (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;; (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;; (add-to-list 'completion-at-point-functions #'cape-line)
)

(use-package vertico
  :init
  (vertico-mode)
  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)
  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

(use-package nano-vertico
 :ensure (:host github :repo "rougier/nano-vertico" :files ("nano-vertico.el"))
 :config
 ;; (nano-vertico-mode 1)
)

(use-package consult
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root)))
  )

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  ;; :bind (:map minibuffer-local-map
  ;;       ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package yasnippet
  :demand t
  :config
  (yas-global-mode 1)
  (yas-minor-mode-on))
(use-package yasnippet-snippets
  :demand t)

;; LATEX
;; #+CITE_EXPORT: csl vancouver.csl
(setq org-cite-csl-styles-dir (concat bread-dir "cls")
      org-cite-export-processors '((t csl))
      )

(use-package citeproc)

(require 'zen-mode)

(use-package org-ai
  :ensure t
  :commands (org-ai-mode
             org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode) ; enable org-ai in org-mode
  (org-ai-global-mode) ; installs global keybindings on C-c M-a
  :config
  ;; (setq org-ai-default-chat-model "gpt-4") ; if you are on the gpt-4 beta:
  (setq org-ai-image-directory (concat org-directory "/images"))
  (org-ai-install-yasnippets)) ; if you are using yasnippet and want `ai` snippets

(use-package copilot
  :ensure (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :config
  ;;(add-hook 'prog-mode-hook 'copilot-mode)
  (add-to-list 'copilot-indentation-alist '(org-mode 4))
  )

(use-package shell-maker
  :ensure (:host github :repo "xenodium/shell-maker" :files ("shell-maker*.el")))

(use-package chatgpt-shell
  :ensure (:host github :repo "xenodium/chatgpt-shell" :files ("chatgpt-shell*.el"))
  :config
  (setq chatgpt-shell-model-version "anthropic/claude-3.7-sonnet")
  :custom
  ((chatgpt-shell-openrouter-key open-router-key)))

;; Nano is wierd
;; (require 'nano-mu4e)
(require 'mu4e)

;; Set up some common mu4e variables
(setq mail-user-agent 'mu4e-user-agent
      mu4e-maildir "/Users/italo/Mail/"
      mu4e-mu-version "1.12.1"
      mu4e-get-mail-command "mbsync gmail; mbsync icloud")

;; Contexts
(setq mu4e-contexts
      `(
      ,(make-mu4e-context
	   :name "Gmail"
	   :enter-func (lambda () (mu4e-message "Entering Gmail context"))
	   :leave-func (lambda () (mu4e-message "Leaving Gmail context"))
	   :vars '( ( user-mail-address . "italoamaya03@gmail.com")
		    ( user-full-name . "Italo Amaya" )
		    ( mu4e-compose-signature . "Italo Amaya")
		    ( mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
		    ( mu4e-sent-folder . "/gmail/[Gmail]/Sent Mail")
		    ( mu4e-trash-folder . "/gmail/[Gmail]/Trash")
		    ( mu4e-refile-folder . "/gmail/[Gmail]/All Mail")
		    )
	   :match-func (lambda (msg)
			 (when msg
			   (mu4e-message-contact-field-matches msg :to "italoamaya03@gmail.com"))))
	 ,(make-mu4e-context
	   :name "iCloud"
	   :enter-func (lambda () (mu4e-message "Entering iCloud context"))
	   :leave-func (lambda () (mu4e-message "Leaving iCloud context"))
	   :vars '( ( user-mail-address . "italoamaya@me.com")
		    ( user-full-name . "Italo Amaya" )
		    ( mu4e-compose-signature . "Italo Amaya")
		    ( mu4e-drafts-folder . "/icloud/Drafts")
		    ( mu4e-sent-folder . "/icloud/Sent Messages")
		    ( mu4e-trash-folder . "/icloud/Deleted Messages")
		    ( mu4e-refile-folder . "/icloud/Archive")
		    )
	   :match-func (lambda (msg)
			 (when msg
			   (mu4e-message-contact-field-matches msg :to "italoamaya@me.com"))))

	 )
      )
;; (setq mu4e-dashboard-file (concat mu4e-maildir "mu4e-dashboard.org"))

(use-package elfeed
  :config
  (setq elfeed-feeds
	'("https://sachachua.com/blog/category/emacs-news/feed/index.xml"
	  "https://irreal.org/blog/?feed=rss2"
	  "https://protesilaos.com/news.xml"
	  )))

;; (set-face-attribute 'default nil :font "Monaco")
;; (set-face-attribute 'default nil :font "Andale Mono")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight normal  :height 2.0 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight regular  :height 1.75))))
 '(org-level-2 ((t (:inherit default :weight regular  :height 1.5))))
 '(org-level-3 ((t (:inherit default :weight regular  :height 1.25))))
 '(org-level-4 ((t (:inherit default :weight regular  :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight regular ))))
 '(org-level-6 ((t (:inherit default :weight regular ))))
 '(org-level-7 ((t (:inherit default :weight regular ))))
 '(org-level-8 ((t (:inherit default :weight regular )))))

;; Unbind RET for going to links
;;(elpaca nil (evil-define-key 'normal evil-motion-mode-map (kbd "RET") nil))
;;(elpaca nil (setq org-return-follows-link t
;;                  org-image-actual-width nil))

;; Opens file links in the same window
(add-to-list 'org-link-frame-setup '(file . find-file))

(setq org-startup-indented t)
(setq org-edit-src-content-indentation 0)
(setq org-clock-sound (concat user-emacs-directory "bell.wav"))

(setq org-image-actual-width nil)


(require 'org-tempo)
(require 'org-habit)

(require 'ox-extra)
(ox-extras-activate '(latex-header-blocks ignore-headlines))
(add-to-list 'org-modules 'org-habit)

(setq org-agenda-files '("~/org/Agenda/index.org" "~/org/Agenda/project.org"))

(setq meditations-dir (concat org-directory "/meditations/"))

(setq org-columns-default-format
      "%TODO %25ITEM %DEADLINE")

(setq org-agenda-view-columns-initially t)

(setq org-agenda-custom-commands
      '(("p" "Projects agenda"
	 ((agenda "" ((org-agenda-span 'week)
		      (org-agenda-overriding-header "Weekly")))
	  (tags-todo "+Graphics"
		     ((org-agenda-overriding-header "Graphics Todos")))
	  (tags-todo "+Individual"
		     ((org-agenda-overriding-header "Dissertation Todos")))
	  ))
        ))

;; Function to generate the file path with title
(defun generate-meditation-file-path ()
  (let* ((title (read-string "Title: ")) ; Prompt for the title
         (formatted-title (replace-regexp-in-string " " "_" title)) ; Replace spaces with underscores
         (filename (concat (format-time-string "%Y-%m-%d_") formatted-title ".org"))) ; Correctly format filename
    (expand-file-name filename meditations-dir))) ; Return full path

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/Agenda/index.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
	("p" "Project Task")
	("pg" "Graphics" entry (file+headline "~/org/Agenda/project.org" "Graphics")
	 "* TODO %? :Graphics:\nDEADLINE: %^t\nSCHEDULED: %t\n%i\n %a"
	 )
	("pc" "Complex graphs" entry (file+headline "~/org/Agenda/project.org" "Complex graphs")
	 "* TODO %? :ComplexGraphs:\nDEADLINE: %^t \n%i\n %a"
	 )
	("pi" "Individual project" entry (file+headline "~/org/Agenda/project.org" "Individual project")
	 "* TODO %? :Individual:\nDEADLINE: %^t \n%i\n %a"
	 )
	("pm" "Machine learning project" entry (file+headline "~/org/Agenda/project.org" "Machine learning project")
	 "* TODO %? :ML:\nDEADLINE: %^t \n%i\n %a"
	 )
	("ps" "Secure computing project" entry (file+headline "~/org/Agenda/project.org" "Secure computing project")
	 "* TODO %? :SecureComp:\nDEADLINE: %^t \n%i\n %a"
	 )
        ("m" "Meditation Entry" plain (file generate-meditation-file-path)
         "#+title: %?\nEntered on %U\n\n%i\n" :empty-lines 1)
	)
      )

(require 'epa-file)
(setq epg-pinentry-mode 'loopback)
(epa-file-enable)
(setq epg-gpg-program "/usr/local/bin/gpg")
(setq plstore-cache-passphrase-for-symmetric-encryption t)

(use-package org-gcal)

(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
(setq org-latex-pdf-process
    '("pdflatex -interaction nonstopmode -output-directory %o %f"
        "pdflatex -interaction nonstopmode -output-directory %o %f"
        "pdflatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-with-hyperref nil) ;; stop org adding hypersetup{author..} to latex export
;; (setq org-preview-latex-default-process "dvipng")
;; (setq org-preview-latex-default-process "dvisvgm")
;; (plist-put org-format-latex-options :foreground nil)
;; (plist-put org-format-latex-options :background nil)

(use-package engrave-faces
  :ensure t
  :init
  (setq org-latex-src-block-backend 'engraved))

(use-package org-roam
  :config
  (org-roam-db-autosync-mode 1)
  (setq org-roam-completion-everywhere t)
  )

(setq org-roam-directory (concat org-directory "/roam/"))
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-direction)
               (direction . right)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))

;; Searching for nodes now includes a tag
(setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:50}" 'face 'org-tag)))

(setq org-roam-capture-templates
      '(("m" "Math")
	("ms" "Statistics" plain "\n\n\n* Main\n%?\n\n* References\n"
	 :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
			    "#+title: ${title}\n#+filetags: :Math:Statistics:\n")
	 :unnarrowed t)
	("mn" "Normal" plain "\n\n\n* Main\n%?\n\n* References\n"
	 :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
			    "#+title: ${title}\n#+filetags: :Math:\n")
	 :unnarrowed t)

        ("p" "Physics" plain "\n\n\n* Main\n%?\n\n* References\n"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :Physics:\n")
         :unnarrowed t)

        ("f" "Finance" plain "\n\n\n* Main\n%?\n\n* References\n"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :Finance:\n")
         :unnarrowed t)

        ("J" "Japanese" plain "\n\n\n* Main\n%?\n\n* References\n"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :Japanese:\n")
         :unnarrowed t)

        ("e" "Economics" plain "\n\n\n* Main\n%?\n\n* References\n"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :Economics:\n")
         :unnarrowed t)

        ("p" "Philosophy" plain "\n\n\n* Main\n%?\n\n* References\n"
        :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :Philosophy:\n")
        :unnarrowed t)
        ("j" "Job")
            ("ji" "Interview" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Job:Interview:\n")
            :unnarrowed t)
            ("jc" "Company" plain "\n\n\n* Main\n_Research Sources_:\n- [ ] Company website\n- [ ] Glassdoor\n** TODO Job Description\n- Role: \n- Deadlines: \n- Location: \n** TODO Culture and Values\n*** Recruitment Process\n** TODO Business overview\n*** Products\n*** Industry and Market position\n*** Financial Performance\n** TODO Career Development\n*** Growth opportunities\n*** Learning and Development\n** TODO Recent News and Events\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Job:Company:\n")
            :unnarrowed t)
            ("ja" "Application" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Job:Application:\n")
            :unnarrowed t)
            ("jn" "Networking" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Job:Networking:\n")
            :unnarrowed t)

        ("c" "CompSci")
	    ("cn" "CompSci normal note" plain "\n\n\n* Main\n%?\n\n* References\n"
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+filetags: :CompSci:\n")
                :unnarrowed t)
            ("cp" "Programming")
                ("cpp" "Problem" plain "\n\n\n* Main\n%?\n\n* References\n"
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+filetags: :CompSci:Programming:Problem:\n")
                :unnarrowed t)
                ("cpl" "Language" plain "\n\n\n* Main\n%?\n\n* References\n"
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+filetags: :CompSci:Programming:Language:\n")
                :unnarrowed t)
            ("cc" "Cybersecurity" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :CompSci:Cybersecurity:\n")
            :unnarrowed t)

        ("ca" "AI")
            ("cam" "Machine Learning")
                ("camm" "Model Note" plain "\n\n\n* Main\n%?\n\n* References\n"
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+filetags: :CompSci:AI:MachineLearning:Model:\n")
                :unnarrowed t)
                ("camn" "Normal Machine Learning Note" plain "\n\n\n* Main\n%?\n\n* References\n"
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+filetags: :CompSci:AI:MachineLearning:\n")
                :unnarrowed t)
            ("can" "Normal Model (no involving ML)" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :CompSci:AI:Model:\n")
            :unnarrowed t)
	("r" "Reasearch/Source")
            ("ra" "Article Analysis Note" plain "\n\n\n* Abstract\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Research:Article:\n")
            :unnarrowed t)
            ("rb" "Book Analysis Note" plain "\n\n\n* Main\n%?\n\n* References\n"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                "#+title: ${title}\n#+filetags: :Research:Book:\n")
            :unnarrowed t)
        ))

;; Made by chat gpt I dont understand it but it works
(defun add-university-tag-and-course ()
  "Add the university tag and prompt user to select a course."
  (interactive)
  (let* ((filename (buffer-file-name)) ; Get the name of the current file
         (course (completing-read "Select University Course: "
                                  '("IndividualProject" "SecureComputing" "MachineLearning" "ComputerGraphics" "GraphsAlgoComplxTheo")
                                  nil t))
         (tag-to-add (concat "University:" course ":"))
         (current-tags (save-excursion
                         (goto-char (point-min))
                         (when (re-search-forward "#\\+filetags:.*" nil t)
                           (match-string 0)))))
    (if (and filename (not (string-empty-p current-tags)))
        (with-current-buffer (find-file-noselect filename)
          (goto-char (point-min))
          (if (re-search-forward "#\\+filetags:.*" nil t)
              (replace-match (concat current-tags tag-to-add))
            (goto-char (point-max))
            (insert (concat "#+filetags: " tag-to-add "\n")))
          (save-buffer))
      (message "Not visiting a file or no tags found!"))))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

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

(use-package zotxt)

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t        ;; A default setting that needs to be    t for org-appear
        org-appear-autoemphasis t        ;; Enable org-appear on emphasis (bold, italics, etc)
        org-appear-autolinks nil        ;; Don't enable on links
        org-appear-autosubmarkers t))    ;; Enable on subscript and superscript

;;(use-package org-bullets
;;    :hook (org-mode . org-bullets-mode)
;;    :custom
;;    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;    (org-bullets-bullet-list '("◉" "○" "■" "◆" "▲" "▶")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t) (python . t) (emacs-lisp . t) (C . t)))

(setq org-confirm-babel-evaluate nil)

(use-package org-modern
  :after org
  :config
  (set-face-attribute 'org-modern-label nil
                      :height 150)
  (global-org-modern-mode))

(use-package org-modern-indent
 :ensure (:host github :repo "jdtsmith/org-modern-indent")
 :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))
(use-package org-sidebar
  :ensure (:host github :repo "alphapapa/org-sidebar"))
;; (use-package org-tidy
;;   :ensure t
;;   :hook
;;   (org-mode . org-tidy-mode))

(use-package org-present)

(use-package org-journal
  :config
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-dir (concat org-directory "/journal/")
        org-journal-date-format "%a, %d-%m-%Y"
        org-journal-file-format "%d-%m-%Y.org"
        org-journal-time-prefix "* ")
  )

(use-package ox-reveal)
(use-package htmlize)

(use-package ob-async)

;; (use-package ob-nixn)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :after ox
  :config
  )

(add-hook 'prog-mode-hook #'hs-minor-mode)

(use-package rust-mode
  :config
  (setq rust-format-on-save t
	rust-rustfmt-bin "/Users/italo/.cargo/bin/rustfmt"
	rust-cargo-bin "/Users/italo/.cargo/bin/cargo"))

(add-hook 'rust-mode-hook 'lsp-deferred) ;; Load lsp when in a rust buffer

(add-hook 'c-mode-hook 'lsp)

(add-hook 'c++-mode-hook 'lsp)

(use-package fancy-compilation)

;;; From https://robbmann.io/posts/emacs-eglot-pyrightconfig/ Thanks!!
(defun pyrightconfig-write (virtualenv)
  (interactive "DEnv: ")

  (let* (;; file-truename and tramp-file-local-name ensure that neither `~' nor
         ;; the Tramp prefix (e.g. "/ssh:my-host:") wind up in the final
         ;; absolute directory path.
         (venv-dir (tramp-file-local-name (file-truename virtualenv)))

         ;; Given something like /path/to/.venv/, this strips off the trailing `/'.
         (venv-file-name (directory-file-name venv-dir))

         ;; Naming convention for venvPath matches the field for
         ;; pyrightconfig.json.  `file-name-directory' gets us the parent path
         ;; (one above .venv).
         (venvPath (file-name-directory venv-file-name))

         ;; Grabs just the `.venv' off the end of the venv-file-name.
         (venv (file-name-base venv-file-name))

         ;; Eglot demands that `pyrightconfig.json' is in the project root
         ;; folder.
         (base-dir (vc-git-root default-directory))
         (out-file (expand-file-name "pyrightconfig.json" base-dir))

         ;; Finally, get a string with the JSON payload.
         (out-contents (json-encode (list :venvPath venvPath :venv venv))))

    ;; Emacs uses buffers for everything.  This creates a temp buffer, inserts
    ;; the JSON payload, then flushes that content to final `pyrightconfig.json'
    ;; location
    (with-temp-file out-file (insert out-contents))))

(setq python-shell-interpreter (concat gnus-home-directory ".local/venv/ai/bin/python3")
      python-shell-virtualenv-root (concat gnus-home-directory ".local/venv/ai/")
      org-babel-python-command (concat gnus-home-directory ".local/venv/ai/bin/python3"))
      ;; lsp-pyright-venv-path "/usr/local/anaconda3")

(use-package nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(use-package emmet-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . emmet-mode))

(use-package astro-ts-mode)
;; Hook when a .astro file is opened
(add-to-list 'auto-mode-alist '("\\.astro\\'" . astro-ts-mode))

(use-package markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(use-package lua-mode)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . astro-ts-mode))

(use-package yaml-mode)

(use-package dockerfile-mode)
(use-package docker-compose-mode)

(use-package csv-mode)

(set-scroll-bar-mode nil)

;; Recognize .vm files as .txt files
(add-to-list 'auto-mode-alist '("\\.vm\\'" . text-mode))
