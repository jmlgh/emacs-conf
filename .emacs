(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(package-selected-packages
   (quote
    (expand-region multiple-cursors neotree cargo rust-mode exec-path-from-shell go-mode ocodo-svg-modelines smart-mode-line diff-hl typescript-mode all-the-icons jedi color-theme-sanityinc-tomorrow afternoon-theme autopair auto-complete-c-headers ac-c-headers yasnippet auto-complete cider clojure-mode clojure-mode-extra-font-locking paredit projectile rainbow-delimiters tagedit dash elpy helpful magit pyvenv smex zenburn-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(menu-bar-mode -1) 					 ;; disable menu bar
(tool-bar-mode -1) 					 ;; disable tool bar
(toggle-scroll-bar -1)                                   ;; disable scrollbar


;;(require 'doom-modeline)
;;(doom-modeline-mode 1)

;; smart modeline
(sml/setup)

;; ocodo modeline
;;(ocodo-svg-modelines-init)
;;(smt/set-theme 'ocodo-kawaii-light-smt)
;;(smt/set-theme 'ocodo-geometry-flakes-smt)


;; ido-mode
(require 'ido)
(ido-mode)

;; themes
;;(load-theme 'zenburn t) 				 ;; zenburn theme
(require 'color-theme-sanityinc-tomorrow)


(smex-initialize)					 ;; smex
(when (version<= "26.0.50" emacs-version )		 ;; line numbers
  (global-display-line-numbers-mode))
  
(global-set-key (kbd "M-x") 'smex)			 ;; smex configuration
(global-set-key (kbd "M-X") 'smex-major-mode-commands)	 ;; smex configuration 2
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; start auto-complete with emacs
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
;; start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode 1)

;; lets define a function which initializes auto-complete-c-headers
;; and gets called for c/c++ hooks
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
   ;; c headers
  (add-to-list 'achead:include-directories '"/usr/include")
   ;; c++ headers
   (add-to-list 'achead:include-directories '"/usr/include/c++/7")
)

;; now lets call this function from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;; fullheigt
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; electric pair mode enabled
(electric-pair-mode 1)

;; set interpreter to python3
(setq python-shell-interpreter "python3")

;; configure jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; like git-gutter
(global-diff-hl-mode)

;; get the PATH environment for golang
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;; GOTPATH
;;(setenv "GOPATH" "/home/javi/code/go/projects") ;; --> GOPATH should be set up dinamically with .envrc

;; rust minor mode
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
