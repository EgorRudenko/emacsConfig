;; -*- lexical-binding: t; -*-

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
  (corfu-popupinfo-mode))
					
(use-package eglot
  :ensure t
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
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

(use-package cape
  :ensure
  :init
  (add-to-list 'completion-at-point-functions
               #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions
               #'cape-file))
