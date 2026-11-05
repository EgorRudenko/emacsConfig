;; -*- lexical-binding: t; -*-


(defun insert-file-path-with-completion-relative()
  (interactive)
  (insert (file-relative-name
           (read-file-name "File: ")
           default-directory)))

(defun insert-file-path-with-completion-global()
  (interactive)
  (let ((file (read-file-name "File: ")))
    (insert (expand-file-name file))))

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

(defun pyide-eval-buffer (&optional p1 p2)
  "Execute the current Python buffer and show output in a popup."
  (interactive)
  (if (not p1) (setq p1 (point-min)))
  (if (not p2) (setq p2 (point-max)))
  (let ((output (get-buffer-create "*pyide-output*")))
    (with-current-buffer output
      (setq buffer-read-only nil)
      (erase-buffer))
    (call-process-region
     p1 p2
     "python3"
     nil output t "-")
    (with-current-buffer output
      (setq buffer-read-only t)
      (use-local-map (copy-keymap python-ts-mode-map))
      (local-set-key (kbd "q") (lambda ()
				 (interactive)
				 (quit-window)
				 (kill-buffer output)
				 )))
    (select-window (display-buffer
     output
     '((display-buffer-at-bottom)
       (window-height . 0.3)
       (dedicated . t)))))
  )

(defun pyide ()
  "Quasi-interactive Python shell with a dummy buffer."
  (interactive)
  (switch-to-buffer "pyide.py")
  (python-ts-mode)
  (use-local-map (copy-keymap python-ts-mode-map))
  (local-set-key (kbd "C-c C-c") 'pyide-eval-buffer))


(defun my/display-buffer-and-select (buffer alist)
  (let ((win (display-buffer-pop-up-window buffer alist)))
    (when win
      (select-window win))
    win))
