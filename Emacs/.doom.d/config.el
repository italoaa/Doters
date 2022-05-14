(server-start)
(setq gc-cons-threshold (* 511 1024 1024))
(setq gc-cons-percentage 0.5)
(run-with-idle-timer 5 t #'garbage-collect)
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@me.com")

(setq baby-blue '("#d2ecff" "#d2ecff" "brightblue"))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:



(defvar Dropbox-dir "~/Personal/Dropbox"
  "Path the the directory of dropbox")


(setq doom-theme 'doom-henna
      doom-font (font-spec :family "Roboto Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 18)
      doom-big-font (font-spec :family "Fira Code Retina" :size 24))

(defvar +fl/splashcii-query ""
  "The query to search on asciiur.com")

(defun +fl/splashcii-banner ()
  (mapc (lambda (line)
          (insert (propertize (+doom-dashboard--center +doom-dashboard--width line)
                              'face 'doom-dashboard-banner) " ")
          (insert "\n"))
        (split-string (with-output-to-string
                        (call-process "splashcii" nil standard-output nil +fl/splashcii-query))
                      "\n" t)))

(setq +doom-dashboard-ascii-banner-fn #'+fl/splashcii-banner)

(setq +fl/splashcii-query "nature")


(map! :leader "-" #'+doom-dashboard/open)

(map! :leader "RET" #'so-long-mode)

(setq use-package-compute-statistics nil)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
(add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))

(defcustom which-key-idle-delay 0.1
  "Delay (in seconds) for which-key buffer to popup. This
 variable should be set before activating `which-key-mode'.

A value of zero might lead to issues, so a non-zero value is
recommended
(see https://github.com/justbur/emacs-which-key/issues/134)."
  :group 'which-key
  :type 'float)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(setq which-key-use-C-h-commands 't)

(use-package! dired
  :defer 2
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-file))

(defun fd-switch-dictionary()
      (interactive)
      (let* ((dic ispell-current-dictionary)
    	 (change (if (string= dic "spanish") "english" "spanish")))
        (ispell-change-dictionary change)
        (message "Dictionary switched from %s to %s" dic change)
        ))

(setq org-directory "/Users/italo/Personal/Programing/Emacs/Org"
      org-ellipsis " ▾ "
      org-hide-emphasis-markers t
      org-journal-date-prefix "#+TITLE: "
      org-journal-date-format "%a, %d-%m-%Y"
      org-journal-file-format "%d-%m-%Y.org"
      org-journal-time-prefix "* "
      org-capture-templates '(("x" "Note" entry
                          (file+olp+datetree "journal.org")
                          "**** [ ] %U %?" :prepend t :kill-buffer t)
                         ("t" "Task" entry
                          (file+headline "tasks.org" "Inbox")
                          "* [ ] %?\n%i" :prepend t :kill-buffer t))
      projectile-project-search-path '("~/Personal/Programming/Repos" "~/Dot/"))



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(defun roam-face ()
    (set-face-attribute 'org-roam-title nil
                    :foreground "#ff5555"
                    :background "#1E2029"))
(use-package! websocket
    :after org-roam)

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (setq orb-preformat-keywords '("citekey" "title" "url" "author" "date" "file")
        orb-process-file-keywords t
        orb-attached-file-extensions '("pdf")))

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-download
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
    (require 'org-download))

(use-package! org-ref
  :after org)

(use-package! which-key
    :config (setq which-key-idle-delay 0.1))

(use-package! org-bullets
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "■" "◆" "▲" "▶")))

;; (let ((alternatives '("I-am-doom.png")))

;;   (setq fancy-splash-image
;;         (concat doom-private-dir "splash/"
;;                 (nth (random (length alternatives)) alternatives))))

(defun insert-file-path ()
  "Insert file path."
  (interactive)
  (unless (featurep 'counsel) (require 'counsel))
        (ivy-read "Find file: " 'read-file-name-internal
                  :matcher #'counsel--find-file-matcher
                  :action
                  (lambda (x)
                    (insert x))))

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)


(after! org
  (set-face-attribute 'org-link nil
                      :weight 'normal
                      :background nil)
  (set-face-attribute 'org-code nil
                      :foreground "#a9a1e1"
                      :background nil)
  (set-face-attribute 'org-date nil
                      :foreground "#5B6268"
                      :background nil)
  (set-face-attribute 'org-level-1 nil
                      :foreground "steelblue2"
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :foreground "slategray2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :foreground "DodgerBlue2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-5 nil
                      :weight 'normal)
  (set-face-attribute 'org-level-6 nil
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :foreground "SlateGray1"
                      :background nil
                      :height 1.75
                      :weight 'bold))

(define-key evil-ex-map "W" 'save-buffer)
(define-key evil-ex-map "q" 'save-buffer)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq buffer-auto-save-file-format nil)


(map! :leader
      :desc "Correct Word"
      "t s" #'flyspell-auto-correct-word)

(map! :leader
      :desc "Change Dictionary"
      "t d" #'fd-switch-dictionary)

(map! "C-s" #'swiper)

(map! :leader
      "w C-h" nil)

(map! :leader
      :desc "delete other windows"
      "w w" #'delete-other-windows)

(defconst doom-frame-transparency 96)
(set-frame-parameter (selected-frame) 'alpha doom-frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,doom-frame-transparency))
(defun dwc-smart-transparent-frame ()
  (set-frame-parameter
    (selected-frame)
    'alpha (if (frame-parameter (selected-frame) 'fullscreen)
              100
             doom-frame-transparency)))

(defun vterm-padding ()
  (setq left-margin 5
        ))

(add-hook! 'vterm-mode-hook #'vterm-padding)

(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))

(map! :leader "f i D" #'italo/find/downloads)
(map! :leader "f i d" #'italo/find/doters)
(map! :leader "f i h" #'italo/find/Hugo)
(map! :leader "f i r" #'italo/find/Roam)
(map! :leader "f i R" #'italo/find/Repos)
(map! :leader "j" #'next-buffer)
(map! :leader "k" #'previous-buffer)

(setq company-idle-delay 0.9
      org-startup-with-inline-images t
      org-startup-with-latex-preview t
      org-startup-folded nil)


;; (dap-register-debug-template "My App"
;;   (list :type "python"
;;         :args "-i"
;;         :cwd nil
;;         :env '(("DEBUG" . "1"))
;;         :target-module (expand-file-name "~/src/myapp/.env/bin/myapp")
;;         :request "launch"
;;         :name "My App"))

(after! dap-mode
  (setq dap-python-debugger 'debugpy
        dap-python-executable "python3"
        python-shell-interpreter "python3")
        (require 'dap-python))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

(defun oterm()
  (interactive)
  (vterm)
  (doom/window-maximize-buffer))

(map! :leader
      :desc "Vterm"
      "o v"#'oterm)

(map! :leader
      :desc "Toggle org latex preview"
      "m m" #'org-latex-preview)

(map! :leader
      :desc "Search text recursivelly"
      "s t" #'counsel-rg)

(map! :leader
      :desc "Roam Add Tag"
      "n r t" #'org-roam-tag-add)


(map! :leader
      :desc "Paste Screenshot"
      "n r p" #'org-download-screenshot)

(map! :leader
      :desc "Roam Add Alias"
      "n r a" #'org-roam-alias-add)

(map! :leader
      :prefix ("l" . "LSP")
      :desc "list"
      "l" #'ivy-switch-buffer)

(map! :leader
      :prefix ("g h" . "GHQ")
      :desc "Ghq get"
      "g" #'italo/exec/ghqGet)

(map! :leader
      :desc "Org ui Open"
      "n r u" #'org-roam-ui-open)

(map! :leader
      :desc "Next org header"
      "m j" #'org-next-visible-heading)

(map! :leader
      :desc "Next org header"
      "m k" #'org-previous-visible-heading)

(map! :leader
      :desc "Show lsp ui Doc"
      "l s" #'lsp-ui-doc-show)

(map! :leader
      :desc "Hide lsp ui Doc"
      "l h" #'lsp-ui-doc-hide)

(map! :leader
      :desc "Disable Cursor and Mouse Doc"
      "l d" #'italo/lsp/disableDoc)

(map! :leader
      :desc "Unfocus"
      "l u" #'lsp-ui-doc-unfocus-frame)

(map! :leader
      :desc "Enable Cursor and Mouse Doc"
      "l e" #'italo/lsp/enableDoc)

(map! :leader
      :desc "Glance lsp ui Doc"
      "l g" #'lsp-ui-doc-glance)

(map! :leader
      :desc "Focus lsp ui Doc"
      "l f" #'lsp-ui-doc-focus-frame)

(defun italo/lsp/disableDoc ()
  (interactive)
  (setq lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse nil)
  (message "Docs Disabled"))

(defun italo/lsp/enableDoc ()
  (interactive)
  (setq lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-show-with-mouse t)
  (message "Docs Enabled"))

(defun italo/server (ip)
  (interactive "sServer IP: ")
  (setq
   ssh-deploy-root-local (concat doom-private-dir "Servers/")
   ssh-deploy-root-remote (format "/ssh:%s:/home/ito/Deploy/" ip)
   ssh-deploy-async 1
   ssh-deploy-async-with-threads 1))

(defun italo/exec/ghqGet (link)
  (interactive "sRepo Link: ")
  (shell-command (format "ghq get %s" link)))

(defun italo/find/Repos ()
  (interactive)
  (doom-project-find-file "/Users/italo/Personal/Programing/Repos/"))

(defun italo/find/Roam ()
  (interactive)
  (doom-project-find-file org-roam-directory))

(defun italo/find/Hugo ()
  (interactive)
  (doom-project-find-file (concat org-directory "/Hugo/")))

(defun italo/find/doters ()
  (interactive)
  (doom-project-find-file "~/Dot/"))

(defun italo/find/downloads ()
  (interactive)
  (doom-project-find-file "~/Downloads/"))

(setq confirm-kill-emacs nil)

(use-package! olivetti
  :config
  (setq olivetti-margin-width 100))

(setq org-roam-directory (concat org-directory "/roam/"))

(setq org-agenda-files (directory-files-recursively org-directory "org$"))

(setq +snippets-dir "~/Personal/Programing/Emacs/Snippets/")

(setq org-roam-capture-templates '(("d" "default" plain "\n\n\n* Main\n%?\n\n* References\n" :target
  (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :%^{Select Tag|Physics|Math|AppliedMaths|CompSci|Programming}:\n")
  :unnarrowed t)
                                   (
                                    "r" "bibliography Reference" plain
                                    (file "~/.doom.d/reftemp.org")
                                    :target
                                    (file+head "reference-${citekey}.org" "#+title: ${title}\n")
                                    :unarrowed t
                                    )))

(yas-global-mode 1)

(setq scroll-margin 8
      org-hugo-base-dir (concat org-directory "/Hugo/"))
(setq tramp-default-method "ssh")

(smooth-scrolling-mode 1)

(load "~/Dot/Emacs/.doom.d/publish.el")

(defun italo/Publish/Hugo ()
  (interactive)
  (setq default-directory org-roam-directory)
  (shell-command "PubHugo")
  (hugcis/publish-lines (concat org-roam-directory "list.txt"))
  (setq default-directory org-hugo-base-dir)
  (shell-command "hugo -D;hugo server"))

(setq flycheck-rust-cargo-executable "/Users/italo/.cargo/bin/cargo"
      flycheck-rust-executable "/Users/italo/.cargo/bin/rustc"
      flycheck-rust-clippy-executable "/Users/italo/.cargo/bin/cargo-clippy"
      flycheck-rustic-clippy-executable "/Users/italo/.cargo/bin/cargo-clippy")

(use-package! lsp-ui
  :after lsp
  :config
  (setq lsp-ui-sideline-show-hover t
      lsp-ui-sideline-show-code-actions t
      lsp-ui-doc-show-with-cursor nil
      lsp-ui-doc-show-with-mouse t
      lsp-ui-doc-max-width 150
      lsp-ui-doc-max-height 100
      lsp-ui-doc-position "Top"))

(add-hook! rust-mode-hook #'tree-sitter-mode)
(add-hook! tree-sitter-mode-hook #'tree-sitter-hl-mode)

(use-package! tree-sitter
  :after lsp
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(setq bibtex-completion-bibliography "/Users/italo/Personal/OneDrive - Leeds Beckett University/CW3/refs.bib")
(setq org-latex-pdf-process (list
   "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(use-package! org-ref-ivy
  :after org
  :config
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
      org-ref-insert-label-function 'org-ref-insert-label-link
      org-ref-insert-ref-function 'org-ref-insert-ref-link
      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))

(use-package! svg-tag-mode
  :after org
  :config
  (setq svg-tag-tags
        '(
          ("\\(:[A-Z]+:\\)" . ((lambda (tag)
                                 (svg-tag-make tag :beg 1 :end -1))))
          ("\\(=[A-Z]+=\\)" . ((lambda (tag)
                                 (svg-tag-make tag :beg 1 :end -1))))
        )
  ))

(use-package! exec-path-from-shell
 :custom
 (shell-file-name "/usr/local/bin/fish" "This is necessary because some Emacs install overwrite this variable")
 (exec-path-from-shell-variables '("PATH" "MANPATH" "PKG_CONFIG_PATH") "This adds PKG_CONFIG_PATH to the list of variables to grab. I prefer to set the list explicitly so I know exactly what is getting pulled in.")
 :init
  (if (string-equal system-type "darwin")
    (exec-path-from-shell-initialize)))

;; (add-to-list 'load-path "/Users/italo/Personal/Programing/Repos/github.com/skyler544/doom-nano-testing/")
;; (require 'load-nano)
