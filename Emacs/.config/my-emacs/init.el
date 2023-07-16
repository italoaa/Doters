;;; init.el --- This is Italo Amaya basic emacs config -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Italo Amaya Arlotti
;;
;; Author: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Maintainer: Italo Amaya Arlotti <italoamaya@icloud.com>
;; Created: July 15, 2023
;; Modified: July 15, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/italo/init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This is Italo Amaya basic emacs config
;;
;;; Code:

(org-babel-load-file
 (expand-file-name ".config/my-emacs/config.org"))



;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("467dc6fdebcf92f4d3e2a2016145ba15841987c71fbe675dcfe34ac47ffb9195" "7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525" default))
 '(package-selected-packages
   '(lsp-pyright emmet-mode flycheck company lsp-ui lsp-mode org-bullets which-key use-package switch-window swiper smex projectile magit key-chord ido-vertical-mode evil doom-themes dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight bold :font "Monaco" :height 2.0 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :font "Monaco" :height 1.75))))
 '(org-level-2 ((t (:inherit default :weight bold :font "Monaco" :height 1.5))))
 '(org-level-3 ((t (:inherit default :weight bold :font "Monaco" :height 1.25))))
 '(org-level-4 ((t (:inherit default :weight bold :font "Monaco" :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight bold :font "Monaco"))))
 '(org-level-6 ((t (:inherit default :weight bold :font "Monaco"))))
 '(org-level-7 ((t (:inherit default :weight bold :font "Monaco"))))
 '(org-level-8 ((t (:inherit default :weight bold :font "Monaco")))))
