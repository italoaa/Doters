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

(provide 'early-init)
;;; early-init.el ends here
