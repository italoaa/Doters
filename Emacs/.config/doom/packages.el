;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.
(package! exec-path-from-shell)
(package! smooth-scrolling)
;; (package! beacon)
;; (package! ivy-bibtex)
(package! tree-sitter)
(package! tree-sitter-langs)

;; Nice sticky header for functions
(package! topsy
  :recipe (:host github :repo "alphapapa/topsy.el" :branch "master"))

(package! olivetti)

;; Align tables
(package! valign)

;;; Themes
;; (package! poet-theme)
;; (package! modus-themes)
;; (package! solo-jazz-theme)
;; (package! srcery-theme)
;; (package! tron-legacy-theme)

;; Show colors
;; (package! rainbow-mode)

;; Org related
(package! org-download)
(package! org-bullets)
;; (package! org-ref)
(package! org-roam-ui)
;; (package! org-noter)
;; (package! org-roam-bibtex)
(package! org-auto-tangle)
(package! org-sticky-header)
(package! org-preview
  :recipe (:host github :repo "karthink/org-preview" :branch "master"))
(package! org-ol-tree
  :recipe (:host github :repo "Townk/org-ol-tree" :branch "main"))

;; Debug
;; (package! explain-pause-mode)
