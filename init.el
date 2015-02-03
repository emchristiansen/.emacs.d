;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up el-get, which should have been git cloned into the indicated 
;; directory.

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)
(setq el-get-verbose t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install the desired packages.

(el-get-bundle evil)
(el-get-bundle yasnippet)

(el-get-bundle scala-mode2)
(el-get-bundle sbt-mode)
(el-get-bundle ensime)

(el-get-bundle python-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configure the packages.

(require 'evil)
(evil-mode 1)

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; This may not be necessary.
(setq ensime-sbt-command "/usr/local/google/home/ericmc/bin/sbt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General configuration.

(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))

;; Highlight text that extends beyond 80 characters.
(require 'whitespace)
(setq whitespace-style '(face lines-tail))
(setq whitespace-line-column 80)
(global-whitespace-mode t)

;; Show line and column numbers.
(global-linum-mode t)
(column-number-mode 1)

;; Remove trailing whitespace on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "M-<left>")        'previous-buffer)
(global-set-key (kbd "M-<right>")       'next-buffer)

;; Auto-refresh buffers when disk changes.
(global-auto-revert-mode t)

;; Comment or uncomment flexibly.
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "M-i")        'comment-or-uncomment-region-or-line)

;; Do not make backup files.
;; TODO(emchristiansen): This does not appear to work.
(setq make-backup-files nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook" (add-hook (quote write-contents-functions) (lambda nil (delete-trailing-whitespace) nil)) (require (quote whitespace)) "Sometimes the mode needs to be toggled off and on." (whitespace-mode 0) (whitespace-mode 1)) (whitespace-line-column . 80) (whitespace-style face tabs trailing lines-tail) (require-final-newline . t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Google configuration.

(add-to-list 'auto-mode-alist '("\\.pyplan\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pynet\\'" . python-mode))

(require 'google)

(require 'google-go)

(require 'google-pyformat)
(add-hook 'python-mode-hook
 (lambda ()
   (add-hook 'before-save-hook 'google-pyformat nil t)))

(require 'google-cc-extras)
(google-cc-extras/bind-default-keys)
(defun try-google-clang-format-file()
  (when (eq major-mode 'c++-mode)
    (google-clang-format-file)))
(add-hook 'before-save-hook 'try-google-clang-format-file)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
