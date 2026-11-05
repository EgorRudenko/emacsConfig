;; -*- lexical-binding: t; -*-


(setq custom-file "~/.config/emacs/var/emacs.custom.el")
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "autosave/" user-emacs-directory) t)))

(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/" user-emacs-directory))

(load custom-file t)


(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))


(add-to-list
 'display-buffer-alist
 '("\\*\\(compilation\\|Help\\|grep\\|Man .*\\|EGLOT .*\\|eldoc .*\\)\\*" .
   (my/display-buffer-and-select)))

(setq compilation-scroll-output t)
(setq grep-command  "grep --color=auto -nH --null -re ")
(setq split-width-threshold nil)
