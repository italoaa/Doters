(setq use-package-compute-statistics nil)

(server-start)
(setq gc-cons-threshold (* 511 1024 1024))
(setq gc-cons-percentage 0.5)
(run-with-idle-timer 5 t #'garbage-collect)

(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@me.com")

(setq baby-blue '("#d2ecff" "#d2ecff" "brightblue"))

(defvar Dropbox-dir "~/Personal/Dropbox"
  "Path the the directory of dropbox")


(setq doom-theme 'doom-rouge
      ;; doom-font (font-spec :family "Roboto Mono" :size 16 :height 181 :weight 'light)
      doom-font (font-spec :family "GohuFont" :size 16 :height 181 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 18)
      doom-big-font (font-spec :family "Fira Code Retina" :size 24))

(setq +snippets-dir "~/Personal/Programing/Emacs/Snippets/")

(defconst doom-frame-transparency 85)
(set-frame-parameter (selected-frame) 'alpha doom-frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,doom-frame-transparency))
(defun dwc-smart-transparent-frame ()
  (set-frame-parameter
    (selected-frame)
    'alpha (if (frame-parameter (selected-frame) 'fullscreen)
              100
             doom-frame-transparency)))

;; latex
;; (after! org (plist-put org-format-latex-options :scale 1.75)

(setq display-line-numbers-type 'relative)
(setq confirm-kill-emacs nil)
(setq scroll-margin 8)
(setq tramp-default-method "ssh")
(smooth-scrolling-mode 1)

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

(setq +fl/splashcii-query "dragon")
;; (setq fancy-splash-image (concat doom-private-dir "bonsai.png"))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
(add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))

(map! :leader "f i D" #'italo/find/downloads)
(map! :leader "f i d" #'italo/find/doters)
(map! :leader "f i h" #'italo/find/Hugo)
(map! :leader "f i r" #'italo/find/Roam)
(map! :leader "f i R" #'italo/find/Repos)

(map!
      :leader
      (:prefix-map ("L" . "Library")
       :desc "open Library" "L" (lambda () (interactive)(find-file (concat org-roam-directory "references/Library.bib")))
       :desc "Find entry" "f" #'ivy-bibtex
       :desc "Org Ref Hydra citation" "R" #'org-ref-citation-hydra/body
       :desc "Org Ref Hydra bibtex" "r" #'org-ref-bibtex-hydra/body
       :desc "New entry from DOI" "d" #'doi-add-bibtex-entry
       )
      )

(map!
 :leader
 :desc "ssh deploy hydra panel" "r p" #'ssh-deploy-hydra/body
 )

(map!
      :leader
      :map org-noter-notes-mode-map
      :desc "open org noter" "m n" #'org-noter
      ;; use Hydra to move arround
      )

(map!
      :leader
      :desc "insert bibliographic orb note" "n r b" #'orb-insert-link
      )

;; (map!
;;       :desc "insert bibliographic orb note" "C-i" #'org-roam-node-insert
;;       )

(map! :leader :desc "noter precise note" "n r N i" #'org-noter-insert-precise-note)

(map! :leader
      :desc "Correct Word"
      "t s" #'flyspell-auto-correct-word)

(map! :leader
      :desc "Change Dictionary"
      "t d" #'fd-switch-dictionary)

(map! :after rustic-mode
      :map rustic-mode-map
      :leader
      :desc "Cargo add create"
      "m a" #'rustic-cargo-add)

(map! :leader
      :desc "delete other windows"
      "w w" #'delete-other-windows)

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

(map! :leader
      :desc "Show lsp ui Doc"
      "l s" #'lsp-ui-doc-show)

(map! :leader
      :desc "Hide lsp ui Doc"
      "l h" #'lsp-ui-doc-hide)

(map! :leader
      :desc "Unfocus"
      "l u" #'lsp-ui-doc-unfocus-frame)

(map! :leader
      :desc "Glance lsp ui Doc"
      "l g" #'lsp-ui-doc-glance)

(map! :leader
      :desc "Focus lsp ui Doc"
      "l f" #'lsp-ui-doc-focus-frame)

(map! :leader
      :desc "Next org header"
      "m j" #'org-next-visible-heading)

(map! :leader
      :desc "Next org header"
      "m k" #'org-previous-visible-heading)
(map! :leader
      :desc "Toggle org latex preview"
      "m m" #'org-latex-preview)
(map! :leader
      :desc "Roam Add Tag"
      "n r t" #'org-roam-tag-add)
(map! :leader
      :desc "Paste Screenshot"
      "n r p" #'org-download-clipboard)

(map! :leader
      :desc "Roam Add Alias"
      "n r a" #'org-roam-alias-add)
(map! :leader
      :desc "Org ui Open"
      "n r u" #'org-roam-ui-open)

(map! :leader "-" #'+doom-dashboard/open)
;; (map! "C-[Tab]" #'+fold/toggle)
(map! :leader "RET" #'so-long-mode)
(map! :leader "j" #'next-buffer)
(map! :leader "k" #'previous-buffer)
(map! "C-s" #'swiper)


(map! :leader
      :prefix ("l" . "LSP")
      :desc "list"
      "l" #'ivy-switch-buffer)

(map! :leader
      :desc "Vterm"
      "o v"#'oterm)


(map! :leader
      :desc "Search text recursivelly"
      "s t" #'counsel-rg)

(map! :leader
      :prefix ("g h" . "GHQ")
      :desc "Ghq get"
      "g" #'italo/exec/ghqGet)

(use-package! dired
  :defer 2
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-file)
    )

(beacon-mode 1)

(use-package! ssh-deploy
  :after hydra
  :init
  (setq ssh-deploy-root-local (concat org-directory "/Hugo/")
        ssh-deploy-root-remote "/ssh:root@italoamaya.me:/home/ito/Hugo/"
        ssh-deploy-debug 1
        ssh-deploy-on-explicit-save 0
        ssh-deploy-async 1)
  :config
  (ssh-deploy-hydra "C-c C-z")
  (ssh-deploy-line-mode))

(setq flycheck-rust-cargo-executable "/Users/italo/.cargo/bin/cargo"
      flycheck-rust-executable "/Users/italo/.cargo/bin/rustc"
      flycheck-rust-clippy-executable "/Users/italo/.cargo/bin/cargo-clippy"
      flycheck-rustic-clippy-executable "/Users/italo/.cargo/bin/cargo-clippy")

(yas-global-mode 1)

(use-package! olivetti
  :after org
  :init
  (setq olivetti-body-width 140)
  :hook (org-mode . olivetti-mode)
  :config
  (display-line-numbers-mode 0))

(use-package! nano-theme)

(use-package! websocket
    :after org-roam)

(use-package! which-key
    :config (setq which-key-idle-delay 0.1))

(defun vterm-padding ()
  (setq left-margin 5))

(add-hook! 'vterm-mode-hook #'vterm-padding)

(setq company-idle-delay 0.9)
(use-package! company-box
  :init
  (setq company-box-doc-enable nil
        company-box-doc-delay 0.5
        company-box-tooltip-maximum-width 160
        company-box--top 200
        company-box--height 50
        ))

(use-package! bespoke-themes
  :config
  ;; Set evil cursor colors
  (setq bespoke-set-evil-cursors t)
  ;; Set use of italics
  (setq bespoke-set-italic-comments t
        bespoke-set-italic-keywords t)
  ;; Set variable pitch
  (setq bespoke-set-variable-pitch t)
  ;; Set initial theme variant
  (setq bespoke-set-theme 'dark)
  ;; Load theme
  )

;; we installed this with homebrew
(setq mu4e-mu-binary (executable-find "mu"))

;; this is the directory we created before:
(setq mu4e-maildir "~/Personal/Mail/")

;; this command is called to sync imap servers:
(setq mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;; how often to call it in seconds:
(setq mu4e-update-interval 300)

;; save attachment to desktop by default
;; or another choice of yours:
(setq mu4e-attachment-dir "~/Personal/Mail/Attachments/")

;; rename files when moving - needed for mbsync:
(setq mu4e-change-filenames-when-moving t)

;; list of your email adresses:
(setq mu4e-user-mail-address-list '("italoamaya03@gmail.com"))

;; (setq mu4e-contexts
;;       `(,(make-mu4e-context
;;           :name "gmail"
;;           :enter-func
;;           (lambda () (mu4e-message "Enter italoamaya03@gmail.com context"))
;;           :leave-func
;;           (lambda () (mu4e-message "Leave italoamaya03@gmail.com context"))
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (mu4e-message-contact-field-matches msg
;;                                                   :to "italoamaya03@gmail.com")))
;;           :vars '((user-mail-address . "italoamaya03@gmail.com")
;;                   (user-full-name . "Italo Amaya Arlotti")
;;                   (mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
;;                   (mu4e-refile-folder . "/gmail/[Gmail]/Archive")
;;                   (mu4e-sent-folder . "/gmail/[Gmail]/Sent")
;;                   (mu4e-trash-folder . "/gmail/[Gmail]/Trash")))))

;; (setq mu4e-context-policy 'pick-first) ;; start with the first (default) context;
;; (setq mu4e-compose-context-policy 'ask) ;; ask for context if no context matches;

(after! dap-mode
  (setq dap-python-debugger 'debugpy
        dap-python-executable "python3"
        python-shell-interpreter "python3")
        (require 'dap-python))

(use-package! tree-sitter
  :after lsp
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; The buffer thats imposible to get rid of unless you make a issue on github
(after! lsp-mode
  (setq lsp-signature-render-documentation nil))

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
                      :height 1.5
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :foreground "slategray2"
                      :background nil
                      :height 1.3
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.1
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :foreground "DodgerBlue2"
                      :background nil
                      :height 1.1
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

(setq org-directory "/Users/italo/Personal/Programing/Emacs/Org"
      org-ellipsis " ▾ "
      org-clock-sound (concat doom-private-dir "bell.wav")
      org-agenda-files (directory-files-recursively (concat org-directory "/Agenda/") "org$")
      +org-capture-todo-file (concat org-directory "/Agenda/todo.org")
      org-startup-with-inline-images t
      org-startup-folded nil
      org-startup-with-latex-preview t
      org-hide-emphasis-markers t
      org-journal-date-prefix "#+TITLE: "
      org-journal-date-format "%a, %d-%m-%Y"
      org-journal-file-format "%d-%m-%Y.org"
      org-journal-time-prefix "* "
      projectile-project-search-path '("~/Dot/" "~/Downloads/School/y1/"))



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
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :University:%^{Select Tag|Physics|Math|AppliedMaths|CompSci|Programming}:%^{Select Uni Course|ProcProgramming|ProfessionalComputing|FundamentalMathConcepts|ComputerArchitecture|IntroToProgramming}:\n")
                                    :unnarrowed t)
                                   ("r" "ref" plain "%?" :target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n")
                                    :unarrowed t)
                                   ("n" "ref + noter" plain "%?":target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n\n\n* ${title}\n:PROPERTIES:\n:Custom_ID: ${citekey}\n:URL: ${url}\n:AUTHOR: ${author-or-editor}\n:NOTER_DOCUMENT: ${file}\n:END:")
                                    :unarrowed t)
                                    ))
                                    ;; (file "~/.doom.d/templates/bibnote.org")

(setq! orb-note-actions-interface 'hydra)

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (setq orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "date" "file")
        orb-roam-ref-format 'org-ref-v3
        orb-process-file-keyword t
        orb-attached-file-extensions '("pdf")))

(use-package! org-ol-tree
  :after org
  :commands org-ol-tree
  :hook (org-ol-tree-mode . visual-line-mode)
  :config
  (setq org-ol-tree-ui-window-auto-resize nil
        org-ol-tree-ui-window-max-width 0.3
        org-ol-tree-ui-window-position 'right))
(map! :map org-mode-map
      :after org
      :localleader
      :desc "Outline" "O" #'org-ol-tree)

(use-package! org-sticky-header
  :after org
  :hook (org-mode . org-sticky-header-mode))

(use-package! org-ref
  :after org
  :init
  (setq bibtex-autokey-year-length 4
    bibtex-autokey-name-year-separator "-"
    bibtex-autokey-year-title-separator "-"
    bibtex-autokey-titleword-separator "-"
    bibtex-autokey-titlewords 2
    bibtex-autokey-titlewords-stretch 1
    bibtex-autokey-titleword-length 5
    bibtex-completion-pdf-field "file"
    bibtex-completion-pdf-symbol "⌘"
    bibtex-completion-notes-symbol "✎"
    )
  (setq org-latex-pdf-process (list "latexmk -f -pdf -%latex -interaction=nonstopmode -bibtex -output-directory=%o %f"))

  (setq bibtex-completion-display-formats
    '((article       . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${journal:40}")
      (inbook        . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
      (incollection  . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
      (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
      (t             . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*}")))

  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
      org-ref-csl-default-style (concat org-directory "/templates/harvard-university-of-leeds.csl")
      org-ref-insert-label-function 'org-ref-insert-label-link
      org-ref-insert-ref-function 'org-ref-insert-ref-link
      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
  )

(setq bibtex-completion-bibliography (concat org-roam-directory "references/Library.bib")
      bibtex-completion-library-path (concat org-roam-directory "references/sources/")
)

(use-package! org-noter
  :after org
  :config
  (setq org-noter-notes-search-path (concat org-roam-directory "references/sources/")))

(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package! ox-hugo
  :init
  (setq org-hugo-base-dir (concat org-directory "/Hugo/"))
  :config
  (defun italo/Publish/Hugo ()
    (interactive)
    (setq default-directory org-roam-directory)
    (shell-command "PubHugo")
    (hugcis/publish-lines (concat org-roam-directory "list.txt"))
    (setq default-directory org-hugo-base-dir)
    (shell-command "hugo -D;hugo server"))
  )

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
    (require 'org-download)
    (org-download-enable))

(use-package! org-bullets
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "■" "◆" "▲" "▶")))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

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

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-ex-map "W" 'save-buffer)
(define-key evil-ex-map "q" 'save-buffer)

(defun fd-switch-dictionary()
      (interactive)
      (let* ((dic ispell-current-dictionary)
    	 (change (if (string= dic "spanish") "english" "spanish")))
        (ispell-change-dictionary change)
        (message "Dictionary switched from %s to %s" dic change)
        ))

(defun insert-setup-file()
  (interactive)
  (insert (concat "#+SETUPFILE: " org-directory "/templates/org-plain-latex-export.org")))

(defun insert-file-path ()
  "Insert file path."
  (interactive)
  (unless (featurep 'counsel) (require 'counsel))
        (ivy-read "Find file: " 'read-file-name-internal
                  :matcher #'counsel--find-file-matcher
                  :action
                  (lambda (x)
                    (insert x))))

(defun oterm()
  (interactive)
  (vterm)
  (doom/window-maximize-buffer))

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

(defun italo/exec/ghqGet (link)
  (interactive "sRepo Link: ")
  (shell-command (format "ghq get %s" link)))

(use-package! exec-path-from-shell
 :custom
 (shell-file-name "/usr/local/bin/fish" "This is necessary because some Emacs install overwrite this variable")
 (exec-path-from-shell-variables '("PATH" "MANPATH" "PKG_CONFIG_PATH") "This adds PKG_CONFIG_PATH to the list of variables to grab. I prefer to set the list explicitly so I know exactly what is getting pulled in.")
 :init
  (if (string-equal system-type "darwin")
    (exec-path-from-shell-initialize)))
