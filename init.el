;; -*- lexical-binding: t; -*-

(setq custom-file "~/.emacs.custom.el")
(setq backup-directory-alist '(("." . "~/Documents/.emacs_backups")))
(load-file custom-file)



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

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))

(require 'package)

;; Add MELPA (and optionally MELPA Stable) to package archives
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
        ("melpa" . "https://melpa.org/packages/")))
;; Initialize the package system
(package-initialize)
;;(package-refresh-contents)

;; fix glsl-ts-mode
(defun c-ts-mode--simple-indent-rules(mode style)  (let ((c-ts-mode-indent-style style))
    (c-ts-mode--get-indent-style mode)))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))
(use-package fish-mode :ensure)
(use-package sudo-edit :ensure)
(use-package move-text
  :ensure
  :config
  (move-text-default-bindings))
(use-package vertico
  :ensure
  :config
  (vertico-mode t))
(use-package vertico-directory
  :after vertico
  :ensure nil ;; it's bundled with vertico, no separate package
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)
              ("RET" . vertico-directory-enter))
  ;; tidy shadowed file names when typing absolute/~ paths
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  )
(use-package savehist
  :init
  (savehist-mode))
(use-package orderless
  :ensure
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring
(use-package glsl-mode :ensure)
(use-package treesit-auto
  :ensure
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
(use-package rainbow-mode :ensure)
(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 200))
(use-package vundo :ensure)
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/Notes"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))
(use-package corfu
  ;; :disabled
  :ensure t
  ;; Optional customization
  :custom
  (corfu-cycle t)                 ; Allows cycling through candidates
  (corfu-auto t)                  ; Enable auto completion
  (corfu-auto-prefix 2)
  (corfu-auto-trigger ".")
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-quit-at-boundary 'separator)
  (corfu-preview-current 'insert) ; insert previewed candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
              ("TAB"                 . corfu-next)
              ([tab]                 . corfu-next)
	      ("M-SPC"               . corfu-insert-separator)
              ("S-TAB"               . corfu-previous)
              ([backtab]             . corfu-previous)
              ("S-<return>"          . corfu-insert)
	      ("RET"                 . nil)
	      ([remap next-line]     . nil)
	      ([remap previous-line] . nil)
	      )
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)) ; Popup completion info
(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '(python-base-mode . ("pyright-langserver" "--stdio")))
  :hook ((python-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (c-mode . eglot-ensure)
	 (c++-mode . eglot-ensure)
	 (emacs-lisp-mode . eglot-ensure)))
(use-package org
  :config
  (add-hook 'org-mode-hook 'visual-line-mode)
  (plist-put org-format-latex-options :scale 2)
  (org-display-inline-images)
  (setq org-image-actual-width nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t))) ;; Enable Python
  (setq org-babel-python-command "python3")
  (setq org-startup-with-inline-images t)
)




(defun insert-file-path-with-completion-relative()
  (interactive)
  (insert (file-relative-name
           (read-file-name "File: ")
           default-directory)))
(defun insert-file-path-with-completion-global()
  (interactive)
  (let ((file (read-file-name "File: ")))
    (insert (expand-file-name file))))
(defun openProj () (interactive)(dired "~/Projects"))
(defun backwardKillLine() (interactive)(kill-line 0))
(defun idofile() (interactive)(progn
				(ido-mode t) (ido-find-file) (ido-mode nil)))
(defun point-at-indentation ()
  "return non-nil if point is at indentation, nil otherwise."
  (= (save-excursion (back-to-indentation) (point)) (point)))
(defun beginning-of-line-or-indentation ()
  "Toggle between beginning of line and point of indentation."
  (interactive)
  (if (point-at-indentation)
      (beginning-of-line)
    (back-to-indentation)))
(defun read-file (file)
  "Return first N lines of FILE."
  (with-temp-buffer
    (insert-file-contents-literally file)
    (buffer-substring-no-properties
                             (line-beginning-position)
                             (line-end-position))))
(defun custom-compile ()
  (interactive)
  (if (file-exists-p "emacsCompileCommand.txt")
      (setq compile-command (read-file "emacsCompileCommand.txt")))
  (call-interactively 'compile))
(defun forward-to-word-start ()
  "Move point to the beginning of the next word."
  (interactive)
  (skip-syntax-forward "w")  
  (skip-syntax-forward "^w"))
(defun backward-to-word-end()
  (interactive)
  (skip-syntax-backward "w")
  (skip-syntax-backward "^w"))
(defvar savedClipboard "")
(defun saveToSavedClipboard()
  (interactive)
  (setq savedClipboard (current-kill 0 t))
  )
(defun insertSaved()
  (interactive)
  (insert savedClipboard))

(keymap-global-unset "C-z")
(keymap-global-set "C-z p" 'openProj)
(keymap-global-set "C-c c" 'custom-compile)
(keymap-global-set "C-c g" 'grep)
(keymap-global-set "C-c m" 'man)
;;(keymap-global-set "M-<backspace>" 'backwardKillLine)
(defvar-keymap pathCompletion
    :doc "Path Completion"
    "r" #'insert-file-path-with-completion-relative
    "g" #'insert-file-path-with-completion-global
    )
(keymap-global-set "C-z C-f" pathCompletion)
(keymap-global-set "C-a" 'beginning-of-line-or-indentation)
(keymap-global-set "C-z p" 'pop-to-buffer)
(keymap-global-set "C-z r" 'recentf-open)
(keymap-global-set "M-p" 'backward-to-word-end)
(keymap-global-set "M-n" 'forward-to-word-start)
(keymap-global-set "C-z s" 'saveToSavedClipboard)
(keymap-global-set "C-z y" 'insertSaved)

(load-theme 'modus-operandi t)
(custom-set-faces
 '(font-lock-keyword-face ((t (:weight bold))))
 '(font-lock-type-face ((t (:weight bold))))
 )

(defun my/display-buffer-and-select (buffer alist)
  (let ((win (display-buffer-pop-up-window buffer alist)))
    (when win
      (select-window win))
    win))
(add-to-list
 'display-buffer-alist
 '("\\*\\(compilation\\|Help\\|grep\\|Man .*\\|EGLOT .*\\|eldoc .*\\)\\*" .
 ;;'(".*" .
   (my/display-buffer-and-select)))
(setq compilation-scroll-output t)
(setq grep-command  "grep --color=auto -nH --null -re ")
(setq split-width-threshold nil)
