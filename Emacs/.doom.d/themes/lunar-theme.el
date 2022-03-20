 ; lunar-theme.el --- Custom face theme for Emacs

;; This theme was generated with vimco.el
;; You can get it from:
;; <https://github.com/UwUnyaa/vimco>

;;; Code:
(deftheme lunar)

(custom-theme-set-faces 'lunar
                        '(cursor
                          ((((class color)
                             (min-colors 89))
                            (:background "#aeafad" :foreground "#515052"))))
                        '(underline
                          ((((class color)
                             (min-colors 89))
                            (:underline t :foreground "#88c0d0"))))
                        '(font-lock-warning-face
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :weight bold :foreground "#f44747"))))
                        '(font-lock-type-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#b48ead"))))
                        '(font-lock-preprocessor-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#e7cb93"))))
                        '(font-lock-keyword-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#5e81ac"))))
                        '(font-lock-builtin-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#5e81ac"))))
                        '(font-lock-function-name-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#e7cb93"))))
                        '(font-lock-variable-name-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#5e81ac"))))
                        '(font-lock-string-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#a3be8c"))))
                        '(font-lock-constant-face
                          ((((class color)
                             (min-colors 89))
                            (:foreground "#e7cb93"))))
                        '(font-lock-doc-face
                          ((((class color)
                             (min-colors 89))
                            (:slant italic :foreground "#4c566a"))))
                        '(font-lock-comment-face
                          ((((class color)
                             (min-colors 89))
                            (:slant italic :foreground "#4c566a"))))
                        '(show-paren-match-face
                          ((((class color)
                             (min-colors 89))
                            (:underline t))))
                        '(default
                           ((((class color)
                              (min-colors 89))
                             (:background "#232731" :foreground "#abb2bf"))))
                        '(highline-face
                          ((((class color)
                             (min-colors 89))
                            (:underline t :background "#2c323c"))))
                        '(ac-selection-face
                          ((((class color)
                             (min-colors 89))
                            (:background "#5e81ac" :foreground "#3b4252"))))
                        '(ac-candidate-face
                          ((((class color)
                             (min-colors 89))
                            (:background "#434c5e" :foreground "#d8dee9"))))
                        '(flyspell-duplicate
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :foreground "#d7ba7d"))))
                        '(flyspell-incorrect
                          ((((class color)
                             (min-colors 89))
                            (:underline t :foreground "#f44747"))))
                        '(region
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :background "#3e4452"))))
                        '(mode-line-inactive
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :foreground "#5c6370"))))
                        '(mode-line-buffer-id
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :weight bold :background "#2c323c" :foreground "#d8dee9"))))
                        '(mode-line
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :weight bold :background "#2c323c" :foreground "#d8dee9"))))
                        '(fringe
                          ((((class color)
                             (min-colors 89))
                            (:underline t :foreground "#6a6e7e"))))
                        '(linum
                          ((((class color)
                             (min-colors 89))
                            (:underline t :foreground "#6a6e7e"))))
                        '(isearch
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :background "#5c6370"))))
                        '(isearch-lazy-highlight-face
                          ((((class color)
                             (min-colors 89))
                            (:inverse-video t :background "#5c6370"))))
                        '(dired-directory
                          ((((class color)
                             (min-colors 89))
                            (:weight bold :foreground "#5e81ac")))))

(provide-theme 'lunar)

;; Local Variables:
;; no-byte-compile: t
;; End:
