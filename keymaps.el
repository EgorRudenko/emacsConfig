;; -*- lexical-binding: t; -*-


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
