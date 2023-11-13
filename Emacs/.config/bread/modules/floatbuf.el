;;; floatbuf.el --- Floating buffers -*- lexical-binding: t; -*-
;;; Commentary

;;; Floating buffers for quick creation of editing in a new context, while still seeing buffers behind.

;;; Code:

(defvar floatbuf-frame-params default-frame-alist
  "Frame parameters for floating buffer.")

(defvar floatbuf-top 0.5
  "Top location of floating buffer.
0.0 will make top same as top of parent. 1.0 Will make bottom same as bottom of parent.")

(defvar floatbuf-left 0.5
  "Left location of floating buffer.
0.0 will make left same as left of parent. 1.0 Will make right same as right of parent.")

(defvar floatbuf-width 0.5
  "Width of floating buffer.")

(defvar floatbuf-height 0.6
  "Height of floating buffer.")

(defun floatbuf--make-floatbuf-with-dimensions (top left width height buffer)
  "Make floating buffer displaying BUFFER with WIDTH and HEIGHT at TOP and LEFT."
  (let* ((params (append floatbuf-frame-params
                         `((top . ,top)
                           (left . ,left)
                           (width . ,width)
                           (height . ,height))))
         (parent-frame (selected-frame))
         (frame (window-frame (display-buffer-in-child-frame buffer `((child-frame-parameters . ,params))))))
    (set-frame-parameter parent-frame 'floatbuf-frame frame)))

(defun floatbuf-make-floatbuf-with-buffer (buffer)
  "Make floting buffer with BUFFER."
  (floatbuf--make-floatbuf-with-dimensions floatbuf-top floatbuf-left floatbuf-width
                                           floatbuf-height buffer))

;;;###autoload
(defun floatbuf-make-floatbuf ()
  "Make floting buffer with current buffer"
  (interactive)
  (floatbuf--make-floatbuf-with-dimensions floatbuf-top floatbuf-left floatbuf-width
                                           floatbuf-height (current-buffer)))
;; By italo
(defun floatbuf-make-vterm-buf () 
  "Make a floating buffer with vterm"
  (interactive)
  (floatbuf--make-floatbuf-with-dimensions floatbuf-top floatbuf-left floatbuf-width floatbuf-height (vterm)))

;;;###autoload
(defun floatbuf-delete-floatbuf ()
  "Delete floatbuf in currently selected frame"
  (interactive)
  (delete-frame (frame-parameter (selected-frame) 'floatbuf-frame)))

(provide 'floatbuf)
;;; floatbuf.el ends here
