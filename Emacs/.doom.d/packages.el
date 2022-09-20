;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.
(package! exec-path-from-shell)
(package! org-bullets)
(package! beacon)
(package! org-ref)
(package! ivy-bibtex)
(package! spacemacs-theme)
(package! tree-sitter)
(package! tree-sitter-langs)
(package! tsc)
(package! org-ol-tree
  :recipe (:host github :repo "Townk/org-ol-tree" :branch "main"))
(package! topsy
  :recipe (:host github :repo "alphapapa/topsy.el" :branch "master"))
(package! org-auto-tangle)
(package! org-sticky-header)
(package! smooth-scrolling)
(package! olivetti)
(package! valign)
(package! poet-theme)
(package! dap-mode)
(package! rainbow-mode)
(package! modus-themes)
(package! solo-jazz-theme)
(package! srcery-theme)
(package! org-download)
(package! org-roam-ui)
(package! org-noter)
(package! org-roam-bibtex)
(package! explain-pause-mode)
(package! tron-legacy-theme)
(package! svg-tag-mode)
(package! bespoke-themes
  :recipe (:host github :repo "mclear-tools/bespoke-themes" :branch "main"))
(package! 0x0
  :recipe (:host gitlab :repo "willvaughn/emacs-0x0"))
