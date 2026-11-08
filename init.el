;; -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode)
(global-display-line-numbers-mode)

(select-frame-set-input-focus (selected-frame))
(set-face-attribute 'default nil :height 150)
(setq package-install-upgrade-built-in t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(unless (file-exists-p "~/.emacs.d/init.el")
  (write-region ";; -*- lexical-binding: t; -*-
		(setq load-path (cons \"~/.config/emacs\" load-path))
		(load-file \"~/.config/emacs/init.el\")" nil "~/.emacs.d/init.el")
  (setq load-path (cons "~/.config/emacs" load-path))
)


(load "trivia")


(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(load "packages_config")
(load "functions")
(load "keymaps")


(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/load-theme)
  (my/load-theme (selected-frame)))


(custom-set-faces
 '(font-lock-keyword-face ((t (:weight bold))))
 '(font-lock-type-face ((t (:weight bold))))
 )

;; fix glsl-ts-mode
(defun c-ts-mode--simple-indent-rules(mode style)  (let ((c-ts-mode-indent-style style))
						     (c-ts-mode--get-indent-style mode)))
