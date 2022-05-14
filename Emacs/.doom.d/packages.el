;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

(package! exec-path-from-shell)
(package! org-bullets)
(package! org-ref)
(package! ivy-bibtex)
(package! spacemacs-theme)
(package! tree-sitter)
(package! tree-sitter-langs)
(package! tsc)
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
(package! 0x0
  :recipe (:host gitlab :repo "willvaughn/emacs-0x0"))
