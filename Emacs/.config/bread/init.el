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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b9761a2e568bee658e0ff723dd620d844172943eb5ec4053e2b199c59e0bcc22"
     "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443"
     "3fe1ebb870cc8a28e69763dde7b08c0f6b7e71cc310ffc3394622e5df6e4f0da"
     "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0"
     "2078837f21ac3b0cc84167306fa1058e3199bbd12b6d5b56e3777a4125ff6851"
     "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176"
     "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d"
     "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e"
     "683b3fe1689da78a4e64d3ddfce90f2c19eb2d8ab1bab1738a63d8263119c3f4"
     "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00"
     "ae426fc51c58ade49774264c17e666ea7f681d8cae62570630539be3d06fd964"
     default))
 '(inhibit-startup-screen t)
 '(org-agenda-files '("/Users/italo/org/Agenda/index.org"))
 '(package-selected-packages nil))

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
