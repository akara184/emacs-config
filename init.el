;; -*- coding: utf-8; lexical-binding: t; -*-
;; Emacs init file configurations

;;===============================================================
;; Helper function to open the init file
(defun my-open-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

;; Keybinding to quickly open the init file
(global-set-key (kbd "C-x C-.") 'my-open-init-file)

;;===============================================================
;; UI & Theme Configurations

(setq inhibit-startup-message t)            ;; Disable startup message
(menu-bar-mode -1)                          ;; Disable menu bar
(tool-bar-mode -1)                          ;; Disable tool bar
(scroll-bar-mode -1)                        ;; Disable scroll bar
(global-hl-line-mode 1)                     ;; Highlight current line
(set-fringe-mode 10)                        ;; Set frame edge padding
(column-number-mode t)                      ;; Show column numbers
(setq visible-bell nil)                     ;; Disable visual bell
(recentf-mode 1)                            ;; Enable recent files

;; Show line numbers except in org-mode
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Dashboard configuration
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "/home/akara184/Pictures/vasco1.png"))

;; Load theme and icons
(load-theme 'doom-ayu-dark t)               ;; Load theme
(use-package all-the-icons)                 ;; Load icons
(use-package doom-modeline                  ;; Load doom modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Set default font
(set-face-attribute 'default nil :font "JetBrainsMono" :height 140)

;; Start Emacs in fullscreen mode
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;===============================================================
;; Keybinding and Shortcut Configurations

;; Use 'hydra' for easier keybinding
(use-package hydra)

;; Custom function to select a line
(defun select-line ()
  (interactive)
  (if (region-active-p)
      (progn
        (forward-line 1)
        (end-of-line))
    (progn
      (end-of-line)
      (set-mark (line-beginning-position)))))

;; Unbind and rebind keys
(global-unset-key (kbd "C-q"))              ;; Unbind C-q
(global-set-key (kbd "C-q C-r") 'restart-emacs)
(global-set-key (kbd "C-x e") 'eval-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-z") 'undo)          ;; Standard undo
(global-set-key (kbd "C-Z") 'undo-redo)     ;; Redo
(global-set-key (kbd "C-<tab>") 'other-window)
(global-set-key (kbd "C-;") 'comment-line)
(global-set-key (kbd "C-c C-v") 'duplicate-line)
(global-set-key (kbd "C-l") 'select-line)

(fset 'yes-or-no-p 'y-or-n-p)               ;; Simplify prompts to y/n

;;===============================================================
;; Package Configuration

(require 'package)                          ;; Initialize package manager

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu-devel" . "https://elpa.gnu.org/devel/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; Stop Emacs from cluttering init file with custom-set variables
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; package manager for the Emacs hacker. straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;;===============================================================
;; Error Checking and Auto-complete

;; Flycheck for syntax checking
(use-package flycheck
  :init (global-flycheck-mode)
  (setq flycheck-standard-error-navigation t))

(use-package flycheck-inline
  :hook (flycheck-mode . flycheck-inline-mode))

;; Company-mode for autocompletion
(use-package company
  :diminish
  :defer 2
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  (global-company-mode 1))

(use-package yasnippet)                     ;; Enable yasnippet for snippets

;;===============================================================
;; Development Tools

;; LSP for multiple languages
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :config (lsp-enable-which-key-integration t))

;; SLY for Common Lisp
(use-package sly)

;; LSP for Java
(use-package lsp-java
  :config (add-hook 'java-mode-hook 'lsp))

;; TypeScript support with LSP
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config (setq typescript-indent-level 2))

;; UI enhancements for LSP
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config (setq lsp-ui-doc-mode 1))

(use-package lsp-ivy)
(use-package lsp-treemacs)

(require 'lsp-diagnostics)
(lsp-diagnostics-flycheck-enable)

;; Keybinding helper
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))

;;===============================================================
;; Additional Tools

;; Multiple cursor
(use-package multiple-cursors
  :ensure t
  :bind (("C-M-j"   . mc/mark-all-dwim)    
         ("C-M-c"   . mc/edit-lines)                 
         ("C-M-l"   . er/expand-region)   
         ("C-M-/"   . mc/mark-all-like-this)         
         ("C-M-."   . mc/mark-next-like-this)    
         ("C-M-,"   . mc/mark-previous-like-this)
	 ("C-M-<"   . mc/skip-to-previous-like-this)
	 ("C-M->"   . mc/skip-to-next-like-this)))        

;; To read PDF
(use-package pdf-tools)

;; To open apps in emacs
(use-package app-launcher
  :straight '(app-launcher :host github :repo "SebastienWae/app-launcher"))

;; Rainbow parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Project management
(use-package projectile)

;; File tree view
(use-package neotree
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)
        neo-autorefresh t)
  :bind ("C-\\". 'neotree-toggle))

;; Enhanced help UI
(use-package helpful
  :custom
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)
   ("C-c C-d" . helpful-at-point)))

;; Ivy for better minibuffer completion
;; Ivy configuration
(use-package ivy
  :ensure t
  :diminish
  :init
  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  :bind
  (("C-s" . swiper)  ;; Swiper for search
   ("C-c C-r" . ivy-resume)  ;; Resume last Ivy-based completion
   ("<f6>" . ivy-resume)  ;; Alternate key for resume
   ("C-x C-b" . counsel-switch-buffer)  ;; Switch buffers using counsel
   ("C-r" . counsel-minibuffer-history)))  ;; History search in minibuffer

;; Counsel configuration
(use-package counsel
  :ensure t
  :after ivy
  :bind
  (("M-x" . counsel-M-x)  ;; Enhanced M-x with counsel
   ("C-x C-f" . counsel-find-file)  ;; Find file using counsel
   ("<f1> f" . counsel-describe-function)  ;; Describe function
   ("<f1> v" . counsel-describe-variable)  ;; Describe variable
   ("<f1> o" . counsel-describe-symbol)  ;; Describe symbol
   ("<f1> l" . counsel-find-library)  ;; Find Emacs library
   ("<f2> i" . counsel-info-lookup-symbol)  ;; Lookup symbol in info
   ("<f2> u" . counsel-unicode-char)  ;; Insert Unicode character
   ("C-c g" . counsel-git)  ;; Git integration
   ("C-c j" . counsel-git-grep)  ;; Git grep integration
   ("C-c k" . counsel-ag)  ;; Ag (Silver Searcher) integration
   ("C-x l" . counsel-locate)  ;; Locate files
   ("C-S-o" . counsel-rhythmbox)))  ;; Rhythmbox control

;; Enhance M-x with Counsel
(use-package smex)

;; Pretty Ivy with icons
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

;;===============================================================
;; Org Mode and Enhancements

(use-package org)

;; Pretty org mode with org-superstar
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-special-todo-items t))

;; Custom org emphasis styles
(setq org-emphasis-alist
      '(("*" (bold :slant italic :weight black))
        ("/" (italic :foreground "dark salmon"))
        ("_" underline :foreground "cyan")
        ("=" (:background "snow1" :foreground "deep slate blue"))
        ("~" (:background "PaleGreen1" :foreground "dim gray"))
        ("+" (:strike-through nil :foreground "dark orange"))))
(setq org-hide-emphasis-markers t)

;; TOC support in org-mode
(use-package toc-org)
