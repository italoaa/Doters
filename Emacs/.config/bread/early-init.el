;;; early-init.el --- Code to run before emacs startup -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Italo Amaya Arlotti
;;
;; Author: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Maintainer: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Created: August 22, 2023
;; Modified: August 22, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/italo/early-init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Code to run before emacs startup
;;
;;; Code:

;; This will allow elpaca to be the primary package manager
(setq package-enable-at-startup nil)

;; Unecorated round frame
(add-to-list 'default-frame-alist '(undecorated-round . t))

;; lsp mode
(setenv "LSP_USE_PLISTS" "true")

(defun avoid-initial-flash-of-light ()
  "Avoid flash of light when starting Emacs, if needed.
New frames are instructed to call `prot-emacs-re-enable-frame-theme'."
  (set-face-attribute 'default nil :background "#000000" :foreground "#ffffff")
  (set-face-attribute 'mode-line nil :background "#000000" :foreground "#ffffff" :box 'unspecified)
    )

(avoid-initial-flash-of-light)

(provide 'early-init)
;;; early-init.el ends here
