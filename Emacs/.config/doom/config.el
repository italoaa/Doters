(setq use-package-compute-statistics nil)

;; (setq gc-cons-threshold (100000000))
;; (setq gc-cons-percentage 0.5)
;; (run-with-idle-timer 5 t #'garbage-collect)

(setq backup-by-copying t ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq user-full-name "Italo Amaya Arlotti"
      user-mail-address "italoamaya@icloud.com")

(defvar Dropbox-dir "~/Personal/Dropbox"
  "Path the the directory of dropbox")

;; Themes
;; Spacegrey    Grey and contrast code
;; Miramare     greeny code and creamy text
;; FlatWhite    to highlight instead of changing the color of text
;; Gruvbox      to groove

(setq doom-theme 'doom-spacegrey
      doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :height 181 :weight 'light)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 18)
      doom-big-font (font-spec :family "FiraCode Nerd Font" :size 24))

(setq +snippets-dir "~/Personal/Programing/Emacs/Snippets/")

(defconst doom-frame-transparency 100)
(set-frame-parameter (selected-frame) 'alpha doom-frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,doom-frame-transparency))
(defun dwc-smart-transparent-frame ()
  (set-frame-parameter
    (selected-frame)
    'alpha (if (frame-parameter (selected-frame) 'fullscreen)
              100
             doom-frame-transparency)))

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
      :desc "lsp ivy workspace symbols"
      "l w" #'lsp-ivy-workspace-symbol)

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
(after! evil-collection
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-file)
    )
  )

;; (beacon-mode 1) it is currently uninstalled

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

(add-hook! 'magit-mode-hook #'magit-todos-mode)

;; (use-package! nano-theme)

(use-package! websocket
    :after org-roam)

(use-package! which-key
    :config (setq which-key-idle-delay 0.1))

(defun vterm-padding ()
  (setq left-margin 5))

(add-hook! 'vterm-mode-hook #'vterm-padding)

(setq company-idle-delay 0.5)
(use-package! company-box
  :init
  (setq company-box-doc-enable nil
        company-box-doc-delay 0.5
        company-box-tooltip-maximum-width 160
        company-box--top 200
        company-box--height 50
        ))

;; we installed this with homebrew
(setq mu4e-mu-binary (executable-find "mu"))

;; this is the directory we created before:
(setq mu4e-maildir "~/.maildir")

;; this command is called to sync imap servers:
(setq mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;; how often to call it in seconds:
(setq mu4e-update-interval 300)

;; save attachment to desktop by default
;; or another choice of yours:
(setq mu4e-attachment-dir "~/.maildir/Attachments")

;; rename files when moving - needed for mbsync:
(setq mu4e-change-filenames-when-moving t)

;; list of your email adresses:
(setq mu4e-user-mail-address-list '("italoamaya03@gmail.com"
                                    "italoamaya@icloud.com"))

;; check your ~/.maildir to see how the subdirectories are called
;; for the generic imap account:
;; e.g `ls ~/.maildir/example'
(setq   mu4e-maildir-shortcuts
        '(("/icloud/INBOX" . ?i)
          ("/icloud/Sent Messages" . ?I)
          ("/gmail/INBOX" . ?g)
          ("/gmail/[Gmail]/Sent Mail" . ?G)))

;; (setq mu4e-contexts
;;       `(,(make-mu4e-context
;;           :name "icloud"
;;           :enter-func
;;           (lambda () (mu4e-message "Enter italoamaya@icloud.com context"))
;;           :leave-func
;;           (lambda () (mu4e-message "Leave italoamaya@icloud.com context"))
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (mu4e-message-contact-field-matches msg
;;                                                   :to "italoamaya@icloud.com")))
;;           :vars '((user-mail-address . "italoamaya@icloud.com" )
;;                   (user-full-name . "Italo Amaya")
;;                   (mu4e-drafts-folder . "/icloud/Drafts")
;;                   (mu4e-refile-folder . "/icloud/Archive")
;;                   (mu4e-sent-folder . "/icloud/Sent Messages")
;;                   (mu4e-trash-folder . "/icloud/Deleted Messages")))

;;         ,(make-mu4e-context
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
;;                   (user-full-name . "Italo Amaya")
;;                   (mu4e-drafts-folder . "/gmail/Drafts")
;;                   (mu4e-refile-folder . "/gmail/Archive")
;;                   (mu4e-sent-folder . "/gmail/Sent")
;;                   (mu4e-trash-folder . "/gmail/Trash")))))

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
  (setq lsp-ui-sideline-show-hover nil
      lsp-ui-sideline-show-code-actions t
      lsp-ui-doc-show-with-cursor nil
      lsp-ui-doc-show-with-mouse t
      lsp-ui-doc-max-width 450
      lsp-ui-doc-max-height 400
      lsp-ui-imenu-auto-refresh t
      lsp-ui-doc-position "top"))

(add-hook! rust-mode-hook #'tree-sitter-mode)
(add-hook! tree-sitter-mode-hook #'tree-sitter-hl-mode)

(setq-hook! 'c-mode-hook +format-with-lsp nil)

(after! org
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
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil)))))))

(setq org-directory "/Users/italo/Personal/Programing/Emacs/Org"
      org-ellipsis " ▾ "
      org-clock-sound (concat doom-private-dir "bell.wav")
      org-startup-with-inline-images t
      org-startup-folded nil
      org-clock-clocktable-default-properties '(:maxlevel 4)
      ;; org-startup-with-latex-preview t
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
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :University:%^{Select Tag|Physics|Math|AppliedMaths|CompSci|Programming}:%^{Select Uni Course|ComputerProcessors|DataBases|DiscreteMaths|}:\n")
                                    :unnarrowed t)
                                   ("e" "Comptia Exam note" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :CompSci:CyberSecurity:sec+:\n")
                                    :unnarrowed t)
                                   ("c" "CompSci" plain "\n\n\n* Main\n%?\n\n* References\n" :target
                                    (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :CompSci:%^{Select Further CompSci Topic|CyberSecurity}:\n")
                                    :unnarrowed t)
                                   ("r" "ref" plain "%?" :target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n")
                                    :unarrowed t)
                                   ("n" "ref + noter" plain "%?":target
                                    (file+head "references/${citekey}.org" "#+title: ${title}\n\n\n* ${title}\n:PROPERTIES:\n:Custom_ID: ${citekey}\n:URL: ${url}\n:AUTHOR: ${author-or-editor}\n:NOTER_DOCUMENT: ${file}\n:END:")
                                    :unarrowed t)
                                   ))
;; (file "~/.doom.d/templates/bibnote.org")

;; (setq! orb-note-actions-interface 'hydra)

;; (use-package! org-roam-bibtex
;;   :after org-roam
;;   :config
;;   (setq orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "date" "file")
;;         orb-roam-ref-format 'org-ref-v3
;;         orb-process-file-keyword t
;;         orb-attached-file-extensions '("pdf")))

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

(use-package! org-preview
  :after org
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0)))

(add-hook! 'org-mode-hook #'org-preview-mode)

(use-package! org-sticky-header
  :after org
  :hook (org-mode . org-sticky-header-mode))

;; (use-package! org-ref
;;   :after org
;;   :init
;;   (setq bibtex-autokey-year-length 4
;;     bibtex-autokey-name-year-separator "-"
;;     bibtex-autokey-year-title-separator "-"
;;     bibtex-autokey-titleword-separator "-"
;;     bibtex-autokey-titlewords 2
;;     bibtex-autokey-titlewords-stretch 1
;;     bibtex-autokey-titleword-length 5
;;     bibtex-completion-pdf-field "file"
;;     bibtex-completion-pdf-symbol "⌘"
;;     bibtex-completion-notes-symbol "✎"
;;     )
;;   (setq org-latex-pdf-process (list "latexmk -f -pdf -%latex -interaction=nonstopmode -bibtex -output-directory=%o %f"))

;;   (setq bibtex-completion-display-formats
;;     '((article       . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${journal:40}")
;;       (inbook        . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
;;       (incollection  . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
;;       (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
;;       (t             . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*}")))

;;   (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
;;       org-ref-insert-cite-function 'org-ref-cite-insert-ivy
;;       org-ref-csl-default-style (concat org-directory "/templates/harvard-university-of-leeds.csl")
;;       org-ref-insert-label-function 'org-ref-insert-label-link
;;       org-ref-insert-ref-function 'org-ref-insert-ref-link
;;       org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
;;   )

;; (setq bibtex-completion-bibliography (concat org-roam-directory "references/Library.bib")
;;       bibtex-completion-library-path (concat org-roam-directory "references/sources/")
;; )

;; (use-package! org-noter
;;   :after org
;;   :config
;;   (setq org-noter-notes-search-path (concat org-roam-directory "references/sources/")))

(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package! ox-hugo
  :init
  (setq org-hugo-base-dir (concat org-directory "/personal/")) ;; The path to hugo site
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
               '("altacv" "\\documentclass[10pt,a4paper,ragged2e,withhyper]{altacv}
                    % Change the page layout if you need to
                    \\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}

                    % Use roboto and lato for fonts
                    \\renewcommand{\\familydefault}{\\sfdefault}

                    % Change the colours if you want to
                    \\definecolor{SlateGrey}{HTML}{2E2E2E}
                    \\definecolor{LightGrey}{HTML}{666666}
                    \\definecolor{DarkPastelRed}{HTML}{450808}
                    \\definecolor{PastelRed}{HTML}{8F0D0D}
                    \\definecolor{GoldenEarth}{HTML}{E7D192}
                    \\colorlet{name}{black}
                    \\colorlet{tagline}{PastelRed}
                    \\colorlet{heading}{DarkPastelRed}
                    \\colorlet{headingrule}{GoldenEarth}
                    \\colorlet{subheading}{PastelRed}
                    \\colorlet{accent}{PastelRed}
                    \\colorlet{emphasis}{SlateGrey}
                    \\colorlet{body}{LightGrey}

                    % Change some fonts, if necessary
                    \\renewcommand{\\namefont}{\\Huge\\rmfamily\\bfseries}
                    \\renewcommand{\\personalinfofont}{\\footnotesize}
                    \\renewcommand{\\cvsectionfont}{\\LARGE\\rmfamily\\bfseries}
                    \\renewcommand{\\cvsubsectionfont}{\\large\\bfseries}

                    % Change the bullets for itemize and rating marker
                    % for \cvskill if you want to
                    \\renewcommand{\\itemmarker}{{\\small\\textbullet}}
                    \\renewcommand{\\ratingmarker}{\\faCircle}
                    "

                    ("\\cvsection{%s}" . "\\cvsection*{%s}")
                    ("\\cvevent{%s}" . "\\cvevent*{%s}")
               )
               '("org-plain-latex"
                    "\\documentclass{article}
                        [NO-DEFAULT-PACKAGES]
                        [PACKAGES]
                        [EXTRA]"
                    ("\\section{%s}" . "\\section*{%s}")
                    ("\\subsection{%s}" . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
               )))

(use-package! ox-latex
  :config
  ;; code here will run after the package is loaded
  (setq org-latex-pdf-process
        '("pdflatex -interaction nonstopmode -output-directory %o %f"
          "pdflatex -interaction nonstopmode -output-directory %o %f"
          "pdflatex -interaction nonstopmode -output-directory %o %f"))
  (setq org-latex-with-hyperref nil) ;; stop org adding hypersetup{author..} to latex export
  ;; (setq org-latex-prefer-user-labels t)

  ;; deleted unwanted file extensions after latexMK
  (setq org-latex-logfiles-extensions
        (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist"))))

(after! org
  ;; deleted unwanted file extensions after latexMK
  (setq org-latex-logfiles-extensions
        (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist")))

  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines))))

(after! org-fancy-priorities
  (setq org-fance-priorities-list '("■","■","■")))

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

(defun insert-bibtex-from-jstor-stable-url (link)
  (interactive "sJstor Link: ")
  (shell-command (format (concat "~/.config/Bin/practical/getJstorLink.sh " "'" "%s" "'") link)))

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
  (doom-project-find-file "~/Doters/"))

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
