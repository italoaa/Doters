;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

(package! beacon)
(package! org-bullets)
(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))

(package! spacemacs-theme)
(package! olivetti)
(package! poet-theme)
(package! modus-themes)
(package! solo-jazz-theme)
(package! srcery-theme)
(package! org-download)
(package! org-roam-ui)
