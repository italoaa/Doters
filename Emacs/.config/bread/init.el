;;; init.el --- Init file for initial configuration for emacs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Italo Amaya Arlotti
;;
;; Author: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Maintainer: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Created: August 22, 2023
;; Modified: August 22, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/italo/init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Init file for initial configuration for emacs
;;
;;; Code:

(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))

(provide 'init)
;;; init.el ends here
