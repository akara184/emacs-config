;;===============================================================
;; Disabling package.el
(setq package-enable-at-startup nil)
;;===============================================================
;; Package Configuration
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

(straight-use-package 'use-package) ;; Straight + Use-pacakge

(setq straight-use-package-by-default t) ;; Make sure it all t

;; Automatically debug and bisect your init (.emacs) file!
(use-package bug-hunter)

;;===============================================================
;; Emacs init file configurations

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
(setq make-backup-files nil)                ;; dont make backup file

;; Show line numbers except in org-mode
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Load theme and icons
(use-package all-the-icons)             ;; Load icons
(use-package nerd-icons)                ;; Load icons
(use-package adwaita-dark-theme)        ;; adwaita theme
(load-theme 'adwaita-dark t)            ;; Load theme

(add-to-list 'default-frame-alist '(alpha-background . 99)) ;; For all frame Transparency

;;Dashboard configuration
(use-package dashboard
  :init
  (setq dashboard-items '((recents . 5)
			  (projects . 10))
	dashboard-startup-banner 'logo
	dashboard-set-file-icons t
	dashboard-icon-type 'nerd-icons
	dashboard-heading-icons t
	dashboard-projects-backend 'projectile)
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/images/vasco1.png"))

;; Mood-line for better modeline
(use-package  mood-line
  :config (mood-line-mode)
  :custom (mood-line-glyph-alist mood-line-glyphs-fira-code))

;; Set default font
(set-face-attribute 'default nil :font "JetBrainsMono" :height 130)

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
(global-unset-key (kbd "C-q"))                                        ;; Unbind C-q
(global-set-key (kbd "C-q C-r") 'restart-emacs)                       ;; Restart emacs
(global-set-key (kbd "C-x e") 'eval-buffer)                           ;; Eval buffer
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)               ;; Esc for quit
(global-set-key (kbd "C-z") 'undo)                                    ;; Standard Undo
(global-set-key (kbd "C-Z") 'undo-redo)                               ;; Undo
(global-set-key (kbd "C-<tab>") 'other-window)                        ;; Switch other window
(global-set-key (kbd "C-;") 'comment-line)                            ;; Comment line
(global-set-key (kbd "C-c C-v") 'duplicate-line)                      ;; Duplicate line
(global-set-key (kbd "C-l") 'select-line)                             ;; Select line
(global-set-key (kbd "M-n n") 'centaur-tabs--create-new-empty-buffer) ;; Create new empty buffer
(global-set-key (kbd "C-x K") 'kill-this-buffer) ;; Create new empty buffer

(fset 'yes-or-no-p 'y-or-n-p)                                         ;; Simplify prompts to y/n

;;===============================================================
;; Error Checking and Auto-complete

;; Flycheck for syntax checking
(use-package flycheck
  :init  (global-flycheck-mode)
  :custom
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
  :init (setq lsp-keymap-prefix "C-c l"))

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

;; Keybinding helper
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))

;;===============================================================
;; Additional Tools

;; Magit for GIT
(use-package magit)

;; Multiple cursor
(use-package multiple-cursors
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
;; (use-package app-launcher
;;   :straight '(app-launcher :host github :repo "SebastienWae/app-launcher"))

;; Rainbow parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Project management
(use-package projectile)

;; File tree view
(use-package neotree
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)
        neo-autorefresh t
	neo-show-hidden-files t)
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
   ("C-S-o" . counsel-rhythmbox) ;; Rhythmbox control
   ("C-x C-r" . counsel-recentf)))  ;; Find recents files

;; Enhance M-x with Counsel
(use-package smex)

;; Pretty Ivy with icons
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))


;; Use this to preview in dired
(use-package peep-dired
  :after dired
  :config (setq peep-dired-cleanup-on-disable t))

;;IDK
(use-package ivy-xref
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

;; Tabs in emacs 
(use-package centaur-tabs
  :config
  (setq centaur-tabs-style "bar"
	centaur-tabs-set-bar 'over
	centaur-tabs-set-modified-marker t
	centaur-tabs-modified-marker "*"
	centaur-tabs-set-icons t
	centaur-tabs-plain-icons t
	centaur-tabs-icon-type 'nerd-icons)
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  :bind
  ("C-x <prior>" . centaur-tabs-backward)
  ("C-x <next>" . centaur-tabs-forward)
  :hook
  (dashboard-mode . centaur-tabs-local-mode))

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
