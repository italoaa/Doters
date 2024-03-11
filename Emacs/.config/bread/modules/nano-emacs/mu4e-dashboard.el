;;; mu4e-dashboard.el --- Dashboards for mu4e   -*- lexical-binding: t -*-

;; Copyright (C) 2020-2024 Nicolas P. Rougier

;; Author: Nicolas P. Rougier <Nicolas.Rougier@inria.fr>
;; Homepage: https://github.com/rougier/mu4e-dashboard
;; Keywords: convenience
;; Version: 0.2

;; Package-Requires: ((emacs "27.1") (mu4e) (async) (org))

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; mu4e-dashboard provides enhanced org-mode links that allow you to
;; define custom dashboards that link back to the mu4e email client.
;;
;;
;;; NEWS:
;;
;;
;; Version 0.2
;; - Handle async requests with the async library
;; - Fix package warnings
;; - Added support for mu4e bookmarks
;; - Key bindings from mu4e can be used

;; Version 0.1
;; - initial release

;;; Code:
(require 'subr-x)
(require 'ob-shell)
(require 'org)
(require 'org-element)
(require 'async)
(require 'mu4e-headers)
(require 'mu4e-search)


(defconst mu4e-dashboard-version "0.1.1")

;; Install the mu4e link type
(defgroup mu4e-dashboard nil
  "Provides a new Org mode link type for mu4e queries."
  :group 'comm)

(defcustom mu4e-dashboard-file "~/.emacs.d/mu4e-dashboard.org"
  "Path to the dashboard org file."
  :type 'string)

(defcustom mu4e-dashboard-link-name "mu"
  "Default link name."
  :type 'string)

(defcustom mu4e-dashboard-mu-program "mu"
  "Default name of the mu command."
  :type 'string)

(defcustom mu4e-dashboard-lighter " mu4ed"
  "Minor mode lighter indicating that this mode is active."
  :type 'string)

(defcustom mu4e-dashboard-propagate-keymap t
  "Propagate dashboard defined keymap to mu4e header view."
  :type 'boolean)

(org-link-set-parameters
 mu4e-dashboard-link-name
 :follow #'mu4e-dashboard-follow-mu4e-link)

(defvar mu4e-dashboard--prev-local-keymap nil
  "Buffer-local variable to save the prior keymap.")

(make-variable-buffer-local 'mu4e-dashboard--prev-local-keymap)

(defvar mu4e-dashboard--async-update-in-progress nil
  "Set tot if an async update is in progress.

This is a buffer-local variable that will be t if the current
buffer is in the process of being updated asynchronously.")

(make-variable-buffer-local 'mu4e-dashboard--async-update-in-progress)

;;;###autoload
(define-minor-mode mu4e-dashboard-mode
  "Minor mode for \"live\" mu4e dashboards."
  :lighter mu4e-dashboard-lighter
  :init-value nil
  (if mu4e-dashboard-mode
      (progn
        (setq buffer-read-only t)
        ;; Make a copy of the current local keymap (this will, in
        ;; general, have been setup by org-mode, but I don't want to
        ;; assume that)
        (setq mu4e-dashboard--prev-local-keymap (current-local-map))
	    (use-local-map (make-composed-keymap (mu4e-dashboard-parse-keymap) (current-local-map)))
	    ;; If buffer corresponds to the dashboard, add a special key
	    ;; (buffer-name is harcoded). Dashboard should be open with a
	    ;; special function naming a defcustom buffer name and then
	    ;; install the minor mode.  install the keymap as local with
	    ;; current map as parent (this might generate some problem?)
	    (if (string= (buffer-file-name) (expand-file-name mu4e-dashboard-file))
	        (local-set-key (kbd "<return>") #'org-open-at-point))
	    (add-hook 'mu4e-index-updated-hook #'mu4e-dashboard-update)
	    (if mu4e-dashboard-propagate-keymap
	        ;; install minor mode to mu4e headers view when called
	        ;; (should it be to message hook too?)
	        (add-hook 'mu4e-headers-found-hook #'mu4e-dashboard-mode))
        (mu4e-dashboard-update))
    (if mu4e-dashboard--async-update-in-progress
        (user-error "Update in progress; try again when it is complete"))
    (remove-hook 'mu4e-index-updated-hook #'mu4e-dashboard-update)
    ;; clear hook when dashboard disable
    (remove-hook 'mu4e-headers-found-hook #'mu4e-dashboard-mode)
    (use-local-map mu4e-dashboard--prev-local-keymap)
    (setq buffer-read-only nil)))

(defun mu4e-dashboard ()
  "Open the dashboard (usin mu4e-dashboard-file)."
  (interactive)
  (if (file-exists-p mu4e-dashboard-file)
      (progn
        (find-file mu4e-dashboard-file)
        (mu4e-dashboard-mode))
    (message (concat mu4e-dashboard-file " does not exist"))
    ))

(defun mu4e-dashboard-compare-bookmark-name (bookmark field-name st)
  "Compare ST to the field FIELD-NAME in the BOOKMARK."
  (equal (plist-get bookmark field-name) st))

(defun mu4e-dashboard-find-bookmark (name)
  "Convert a mu4e bookmark NAME to a query."
  (if name
      (cl-find-if (lambda (a) (mu4e-dashboard-compare-bookmark-name a :name name                                                                   ))
                  mu4e-bookmarks)))

(defun mu4e-dashboard-translate-bookmark-to-query (bm)
  "Translates a BM:<bookmarkName> into a mu4e query."
  (let ( ;; remove "bm:" from the begining of the name
        (bookmark (mu4e-dashboard-find-bookmark (substring bm 3)))
        )
    (if bookmark
        ;; put parenthesis around to make it hygenic
          (concat "("(plist-get bookmark :query) ")")
      (progn
        (message (concat "bookmark not found: " bm))
        bm))))

(defun mu4e-dashboard-expand-bookmarks-in-query (st)
  "Replace ST by the corresponding query if ST contain a bookmark."
  (let ((bookmark-re "\\(bm:[^ ]+\\)")
         )
    (replace-regexp-in-string bookmark-re 'mu4e-dashboard-translate-bookmark-to-query  st)
    ))

(defun mu4e-dashboard-follow-mu4e-link (path)
  "Process a mu4e link with path PATH.

PATH shall be of the form [[mu4e:query|fmt|limit][(---------)]].
If FMT is not specified or is nil, clicking on the link calls
mu4e with the specified QUERY (with or without the given
LIMIT).  If FMT is specified, the description of the link is
updated with the QUERY count formatted using the provided
format (for example \"%4d\")."

  (let* ((link    (org-element-context))
         (queryname   (string-trim (nth 0 (split-string path "[]|]"))))
         (query   (mu4e-dashboard-expand-bookmarks-in-query queryname))
         (fmt     (nth 1 (split-string path "[]|]")))
         (count   (nth 2 (split-string path "[]|]"))))
    (cond
     ;; Regular query without limit
     ((and (not fmt) (not count))
      (progn
        (message query)
        (if (get-buffer-window "*mu4e-headers*" t)
            (switch-to-buffer"*mu4e-headers*"))
        (mu4e-search query)))
     
     ;; Regular query with limit
     ((and count (> (length count) 0))
      (progn
        (if (get-buffer-window "*mu4e-headers*" t)
            (switch-to-buffer"*mu4e-headers*"))
        (let ((mu4e-search-results-limit (string-to-number count)))
          (ignore mu4e-search-results-limit)
          (mu4e-search query))))

     ;; Query count and link description update
     ((and fmt (> (length fmt) 0))
       (mu4e-dashboard-update-link link)))))

(defun mu4e-dashboard-update-link (link)
  "Update content of a formatted mu4e LINK.

A formatted link is a link of the form
[[mu4e:query|limit|fmt][(---------)]] where fmt is a non nil
string describing the format.  When a link is cleared, the
description is replaced by a string for the form \"(---)\" and
have the same size as the current description. If the given
format is too big for the current description, description is
replaced with + signs."

  (let* ((path  (org-element-property :path link))
         (queryname (string-trim (nth 0 (split-string path "|"))))
         (query   (mu4e-dashboard-expand-bookmarks-in-query queryname))
         (fmt   (nth 1 (split-string path "|")))
         (beg   (org-element-property :contents-begin link))
         (end   (org-element-property :contents-end link))
         (size  (- end beg)))
    (if (and fmt (> (length fmt) 0))
        (let* ((command (format "%s find %s 2> /dev/null | wc -l" mu4e-dashboard-mu-program
                                (shell-quote-argument query)))
               (output (string-to-number (shell-command-to-string command)))
               (output  (format fmt output)))
          (let ((modified (buffer-modified-p))
                (inhibit-read-only t))
            (save-excursion
              (delete-region beg end)
              (goto-char beg)
              (insert (if (<= (length output) size) output
                        (make-string size ?+))))
            (set-buffer-modified-p modified))))))


(defun mu4e-dashboard-update-all-async ()
  "Update content of all formatted mu4e links in an asynchronous way.

A formatted link is a link of the form
[[mu4e:query|limit|fmt][(---------)]] where fmt is a non nil
string describing the format.  When a link is cleared, the
description is replaced by a string for the form \"(---)\" and
have the same size as the current description."

  (if mu4e-dashboard--async-update-in-progress
      (user-error "Cannot update while an update is in progress!"))
  (setq mu4e-dashboard--async-update-in-progress t)
  (let ((buffer (current-buffer)))
    (org-element-map (org-element-parse-buffer) 'link
      (lambda (link)
        (when (string= (org-element-property :type link) mu4e-dashboard-link-name)
          (let* ((path  (org-element-property :path link))
                 (query (string-trim (nth 0 (split-string path "|"))))
                 (fmt   (nth 1 (split-string path "|")))
                 (beg   (org-element-property :contents-begin link))
                 (end   (org-element-property :contents-end link))
                 (size  (if (and beg end) (- end beg) 0)))
            (when (and fmt (> (length fmt) 0))
                ;; The rest of this function will execute successfully with a
                ;; `size' of zero, but since there would be no reason to
                ;; proceed with no output, we signal an error.
                (if (eq size 0)
                    (error "The link ``%s'' has a format clause, but no output width" path))

                (async-start
                 (lambda ()
                   (let ((command (format "mu find %s 2> /dev/null | wc -l"
                                          (shell-quote-argument query))))
                     (string-to-number (shell-command-to-string command))))
                 (lambda (count)
                   (with-current-buffer buffer
                     (let ((modified (buffer-modified-p))
                           (inhibit-read-only t)
                           (output (if (numberp count)
                                       (format fmt count)
                                     (format fmt 0))))
                       (save-excursion
                         (delete-region beg end)
                         (goto-char beg)
                         (insert (if (<= (length output) size) output
                                   (make-string size ?+))))
                       (set-buffer-modified-p modified)))))))))))
  (setq mu4e-dashboard--async-update-in-progress nil))


(defun mu4e-dashboard-update-all-sync ()
  "Update content of all mu4e formatted links in a synchronous way.

A formatted link is a link of the form
[[mu4e:query|limit|fmt][(---------)]] where fmt is a non nil
string describing the format.  When a link is cleared, the
description is replaced by a string for the form \"(---)\" and
have the same size as the current description."

  (mu4e-dashboard-clear-all)
  (org-element-map (org-element-parse-buffer) 'link
    (lambda (link)
      (when (string= (org-element-property :type link) mu4e-dashboard-link-name)
        (mu4e-dashboard-update-link link)
        (redisplay t)))))

(defun mu4e-dashboard-clear-link (link)
  "Clear a formatted mu4e link LINK.

A formatted link is a link of the form
[[mu4e:query|limit|fmt][(---------)]] where fmt is a non nil
string describing the format.  When a link is cleared, the
description is replaced by a string for the form \"(---)\" and
having the same size as the current description."

  (let* ((path (org-element-property :path link))
         (fmt  (nth 1 (split-string path "|")))
         (beg  (org-element-property :contents-begin link))
         (end  (org-element-property :contents-end link))
         (size (- end beg)))
    (if (and fmt (> (length fmt) 0))
        (let ((modified (buffer-modified-p))
              (inhibit-read-only t))
          (save-excursion
            (delete-region beg end)
            (goto-char beg)
            (insert (format "(%s)" (make-string (- size 2) ?-))))
          (set-buffer-modified-p modified)))))

(defun mu4e-dashboard-clear-all ()
  "Clear all formatted mu4e links.

A formatted link is a link of the form
[[mu4e:query|limit|fmt][(---------)]] where fmt is a non nil
string describing the format.  When a link is cleared, the
description is replaced by a string for the form \"(---)\" and
have the same size as the current description."

  (org-element-map (org-element-parse-buffer) 'link
    (lambda (link)
      (when (string= (org-element-property :type link) mu4e-dashboard-link-name)
        (mu4e-dashboard-clear-link link))))
  (redisplay t))

(defun mu4e-dashboard-update ()
  "Update the current dashboard."
  (interactive)
  ;; (message
  ;;  (concat "[" (propertize "mu4e dashboard" 'face 'bold) "] "
  ;;          (format-time-string "Update (%H:%M)")))
  (dolist (buffer (buffer-list (current-buffer)))
    (with-current-buffer buffer
      (when (bound-and-true-p mu4e-dashboard-mode)
        (if buffer-read-only
            (mu4e-dashboard-update-all-async)
          (error "Dashboard cannot be updated only in read-only mode"))))))

(defun mu4e-dashboard-parse-keymap ()
  "Parse the current buffer file for keybindings.

Keybindings are defined by keywords of type KEYMAP:VALUE and
install the corresponding key bindings in the mu4e-dashboard
minor mode keymap.  The previous keymap (if any) is erased.

VALUE is composed of \"keybinding | function-call\" with
keybinding begin a string describing a key sequence and a call to
an existing function.  For example, to have \"q\" to kill the
current buffer, the syntax would be:

#+KEYMAP: q | kill-current-buffer

This can be placed anywhere in the org file even though I advised
to group keymaps at the same place."

  (let ((map (make-sparse-keymap)))
    (org-element-map (org-element-parse-buffer) 'keyword
      (lambda (keyword)
	(when (string= (org-element-property :key keyword) "KEYMAP")
          (let* ((value (org-element-property :value keyword))
		 (key   (string-trim (nth 0 (split-string value "|"))))
		 (call  (string-trim (nth 1 (split-string value "|")))))
            (define-key map
	      (kbd key)
	      `(lambda () (interactive) ,(car (read-from-string (format "(%s)" call)))))
            (message "mu4e-dashboard: binding %s to %s"
		     key
		     (format "(lambda () (interactive) (%s))" call))))))
    map))

(provide 'mu4e-dashboard)
;;; mu4e-dashboard.el ends here
