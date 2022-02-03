;;; publish.el Used for Hugo -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Italo Amaya Arlotti
;;
;; Author: Italo Amaya Arlotti <https://github.com/italo>
;; Maintainer: Italo Amaya Arlotti <italoamaya@me.com>
;; Created: January 14, 2022
;; Modified: January 14, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/italo/publish
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:
(require 'find-lisp)

(defun hugcis/publish-note (file)
  "Publish a note in FILE."
  (with-current-buffer (find-file-noselect file)
    (projectile-mode -1)
    (let ((org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$")))
        (org-hugo-export-wim-to-md))))

(defun hugcis/delete-current-line ()
  "Delete (not kill) the current line."
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(defun hugcis/publish-lines (filename)
  (with-current-buffer (find-file-noselect filename)
    (goto-char (point-max))
    (while (> (point) (point-min))
      (forward-line -1)
      (let ((org-fname (message (thing-at-point 'line t))))
        (if org-fname ;; if line is empty
            (hugcis/publish-note (replace-regexp-in-string "\n$" "" org-fname))))
      (hugcis/delete-current-line))
    (save-buffer)))

(provide 'publish)
;;; publish.el ends here
