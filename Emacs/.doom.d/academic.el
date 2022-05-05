;; The following packages are needed:
;; 1. elfeed and elfeed-score (available from the rss doom module)
;; 2. citar
;; 3. org-ref
;; 4. org-roam and org-roam-bibtex


(defconst robo/bib-libraries (list "~/bib-lib/robo-lib.bib" "~/bib-lib/robo-temp-lib.bib")) ; All of my bib databases.
(defconst robo/main-bib-library (nth 0 robo/bib-libraries))         ; The main db is always the first
(defconst robo/main-pdfs-library-paths `("~/bib-lib/pdfs/" "/home/robo/bib-lib/temp-pdfs/")) ; PDFs directories in a list
(defconst robo/main-pdfs-library-path (nth 0 robo/main-pdfs-library-paths)) ; Main PDFs directory
(defconst robo/bib-notes-dir "~/bib-lib/roam") ; I use org-roam to manage all my notes, including bib notes.
(setq bibtex-completion-bibliography robo/bib-libraries ; My bibliography PDF location
      bibtex-completion-library-path robo/main-pdfs-library-paths ; My PDF lib location
      bibtex-completion-notes-path robo/bib-notes-dir
      bibtex-completion-pdf-open-function  (lambda (fpath)
                                             (call-process "open" nil 0 nil fpath)))
(use-package! elfeed
  :config
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
  (defun concatenate-authors (authors-list)
    "Given AUTHORS-LIST, list of plists; return string of all authors concatenated."
    (if (> (length authors-list) 1)
        (format "%s et al." (plist-get (nth 0 authors-list) :name))
      (plist-get (nth 0 authors-list) :name)))

  (defun my-search-print-fn (entry)
    "Print ENTRY to the buffer."
    (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
           (title (or (elfeed-meta entry :title)
                      (elfeed-entry-title entry) ""))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (entry-authors (concatenate-authors
                           (elfeed-meta entry :authors)))
           (title-width (- (window-width) 10
                           elfeed-search-trailing-width))
           (title-column (elfeed-format-column
                          title 100
                          :left))
           (entry-score (elfeed-format-column (number-to-string (elfeed-score-scoring-get-score-from-entry entry)) 10 :left))
           (authors-column (elfeed-format-column entry-authors 40 :left)))
      (insert (propertize date 'face 'elfeed-search-date-face) " ")

      (insert (propertize title-column
                          'face title-faces 'kbd-help title) " ")
      (insert (propertize authors-column
                          'kbd-help entry-authors) " ")
      (insert entry-score " ")))
  (defun robo/elfeed-entry-to-arxiv ()
    "Fetch an arXiv paper into the local library from the current elfeed entry."
    (interactive)
    (let* ((link (elfeed-entry-link elfeed-show-entry))
           (match-idx (string-match "arxiv.org/abs/\\([0-9.]*\\)" link))
           (matched-arxiv-number (match-string 1 link)))
      (when matched-arxiv-number
        (message "Going to arXiv: %s" matched-arxiv-number)
        (arxiv-get-pdf-add-bibtex-entry matched-arxiv-number robo/main-bib-library robo/main-pdfs-library-path))))
  (map! (:after elfeed
         (:map elfeed-search-mode-map
          :desc "Open entry" "m" #'elfeed-search-show-entry)
         (:map elfeed-show-mode-map
          :desc "Fetch arXiv paper to the local library" "a" #'robo/elfeed-entry-to-arxiv))
  (setq elfeed-search-print-entry-function #'my-search-print-fn)
  (setq elfeed-search-date-format '("%y-%m-%d" 10 :left))
  (setq elfeed-search-title-max-width 110)
  (setq elfeed-feeds '("http://export.arxiv.org/api/query?search_query=cat:math.OC&start=0&max_results=100&sortBy=submittedDate&sortOrder=descending" "http://export.arxiv.org/api/query?search_query=cat:stat.ML&start=0&max_results=100&sortBy=submittedDate&sortOrder=descending" "http://export.arxiv.org/api/query?search_query=cat:cs.LG&start=0&max_results=100&sortBy=submittedDate&sortOrder=descending"))
  (setq elfeed-search-filter "@2-week-ago +unread"))

(use-package! elfeed-score
  :after elfeed
  :config
  (elfeed-score-load-score-file "~/.doom.d/elfeed.score") ; See the elfeed-score documentation for the score file syntax
  (setq elfeed-score-serde-score-file "~/.doom.d/elfeed.serde.score")
  (elfeed-score-enable)
  (define-key elfeed-search-mode-map "=" elfeed-score-map))

(use-package! org-ref
  :after org
  :config
  (defun robo/reformat-bib-library (&optional filename)
    "Formats the bibliography using biber & rebiber and updates the PDF -metadata."
    (interactive "P")
    (or filename (setq filename robo/main-bib-library))
    (let ((cmnd (concat
                 (format "rebiber -i %s &&" filename) ; Get converence versions of arXiv papers
                 (format "biber --tool --output_align --output_indent=2 --output_fieldcase=lower --configfile=~/bib-lib/biber-myconf.conf --output_file=%s %s && " filename filename) ; Properly format the bibliography
                 (format "sed -i -e 's/arxiv/arXiv/gI' -e 's/journaltitle/journal     /' -e 's/date      /year      /' %s &&" filename) ; Some replacements
                 (format "git commit -m \"Updating bibliography..\" %s && git push" filename) ; Commit and push the updated bib
                 )))
      (async-shell-command cmnd)))
  (defun robo/reformat-bib-lib-hook ()
    "Reformat the main bib library whenever it is saved.."
    (when (equal (buffer-file-name) robo/main-bib-library) (robo/reformat-bib-library)))
  (add-hook 'after-save-hook 'robo/reformat-bib-lib-hook)
  (setq bibtex-dialect 'biblatex))

(use-package! oc
  :config
  (require 'oc-biblatex)
  (require 'oc-csl)
  (require 'citar)
  (setq org-cite-global-bibliography robo/bib-libraries
        org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar
        org-cite-export-processors '((latex biblatex)
                                     (t csl))))

(use-package! citar
  :hook (doom-after-init-modules . citar-refresh)
  :config
  ;; This will add watches for the global bib files and in addition add a hook to LaTeX-mode-hook and org-mode-hook to add watches for local bibliographic files.
  (citar-filenotify-setup '(LaTeX-mode-hook org-mode-hook))
  (require 'citar-org)
  (setq citar-bibliography robo/bib-libraries
        citar-library-paths robo/main-pdfs-library-paths
        citar-file-extensions '("pdf" "org" "md")
        citar-file-open-function #'find-file)
  (defun robo/citar-full-names (names)
    "Transform names like LastName, FirstName to FirstName LastName."
    (when (stringp names)
      (mapconcat
       (lambda (name)
         (if (eq 1 (length name))
             (split-string name " ")
           (let ((split-name (split-string name ", ")))
             (cl-concatenate 'string (nth 1 split-name) " " (nth 0 split-name)))))
       (split-string names " and ") ", ")))
  (setq citar-display-transform-functions
        '((t . citar-clean-string)
          (("author" "editor") . robo/citar-full-names)))
  (setq citar-templates
        '((main . "${author editor:55}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
          (note . "#+title: Notes on ${author editor}, ${title}")))
  ;; use consult-completing-read for enhanced interface
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple))

(map! :leader
      :desc "arXiv paper to library" "n x" #'arxiv-get-pdf-add-bibtex-entry
      :desc "Elfeed" "n e" #'elfeed)

(after! org-roam
  (setq org-roam-v2-ack t
        +org-roam-open-buffer-on-find-file nil
        org-roam-node-display-template "${title:80} ${tags:80}"
        org-roam-completion-everywhere nil
        org-roam-directory robo/bib-notes-dir))

(use-package! org-roam-bibtex
  :config
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :if-new (file+head "${slug}.org"
                              "#+title: ${title}\n#+SETUPFILE: ~/bib-lib/setup_file.org\n* References :ignore:\n#+print_bibliography:")
           :unnarrowed t)
          ;; capture to inbox
          ("i" "inbox" entry "* TODO %?\n"
           :target (node "45acaadd-02fb-4b93-a741-45d37ff9fd5e")
           :unnarrowed t
           :empty-lines-before 1
           :empty-lines-after 1
           :prepend t)
          ;; bibliography note template
          ("r" "bibliography reference" plain "%?"
           :if-new (file+head "references/notes_${citekey}.org"
                              "#+title: Notes on ${title}\n#+SETUPFILE: ~/bib-lib/ref_setup_file.org\n* References :ignore:\n#+print_bibliography:")
           :unnarrowed t)
          ;; for my annotated bibliography needs
          ("s" "short bibliography reference (no id)" entry "* ${title} [cite:@%^{citekey}]\n%?"
           :target (node "01af7246-1b2e-42a5-b8e7-68be9157241d")
           :unnarrowed t
           :empty-lines-before 1
           :prepend t)))
  (defun robo/capture-to-inbox ()
    "Capture a TODO straight to the inbox."
    (interactive)
    (org-roam-capture- :goto nil
                       :keys "i"
                       :node (org-roam-node-from-id "45acaadd-02fb-4b93-a741-45d37ff9fd5e")))
  (require 'org-roam-bibtex)
  (setq citar-open-note-function 'orb-citar-edit-note
        citar-notes-paths '("~/bib-lib/roam/references/")
        orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "keywords" "file")
        orb-process-file-keyword t
        orb-file-field-extensions '("pdf")))