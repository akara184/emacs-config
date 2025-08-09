;;===============================================================s
;; Disabling package.el
(setq package-enable-at-startup nil)
;;===============================================================
;; Disable useless WARNING
(setq warning-minimum-level :emergency)
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
(setq ring-bell-function 'ignore)           ;; Disable visual bell
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

(load-theme 'adwaita-dark t) ;; Load theme


;; cool white theme 
;; (use-package solo-jazz-theme 
;;   :ensure t
;;   :config
;;   (load-theme 'solo-jazz t))

;; (add-to-list 'default-frame-alist '(alpha-background . 99)) ;; For all frame Transparency

;;Dashboard configuration
(use-package dashboard
  :init
  :config  (setq dashboard-items '((recents . 5)
			  (projects . 10))
	dashboard-startup-banner 'logo
	dashboard-set-file-icons t
	dashboard-icon-type 'nerd-icons
	dashboard-heading-icons t
	dashboard-projects-backend 'projectile)

  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/images/vasco1.png"))

;; Mood-line for better modeline
(use-package  mood-line
  :config (mood-line-mode)
  :custom (mood-line-glyph-alist mood-line-glyphs-fira-code))

;; Set default font
(set-face-attribute 'default nil :font "JetBrainsMono" :height 130)

;; Start Emacs in fullscreen mode
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

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

;;To move text up and down
(use-package move-text
  :config
  (progn
    (global-set-key (kbd "C-<up>") 'move-text-up)
    (global-set-key (kbd "C-<down>") 'move-text-down)))

;; Ivy
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
(global-unset-key (kbd "C-\\"))


;;===============================================================
;; Error Checking and Auto-complete

;; Flycheck for syntax checking
(use-package flycheck
  :init  (global-flycheck-mode)
  :custom
  (setq flycheck-standard-error-navigation t
	flycheck-idle-change-delay 5.0
	flycheck-display-errors-delay 0.9
	flycheck-highlighting-mode 'symbols
	flycheck-indication-mode 'left-fringe
	flycheck-standard-error-navigation t
	flycheck-deferred-syntax-check nil))

(use-package flycheck-inline
  :hook
  (flycheck-mode . flycheck-inline-mode))

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

(use-package yasnippet
  :config (yas-global-mode))                     ;; Enable yasnippet for snippets

;;Insert automatically parens pair

(electric-pair-mode t)

(setq-default indent-tabs-mode nil)

;;===============================================================
;; Development Tools

;; LSP for multiple languanges
(use-package lsp-mode
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :config (setq lsp-completion-enable-additional-text-edit t)
  (setq lsp-ui-sideline-show-hover))

;;===============================================================
;; special section for OCAML
(use-package tuareg
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

(use-package dune)

(use-package merlin
  :config
  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'merlin-mode-hook #'company-mode)
  ;; we're using flycheck instead
  (setq merlin-error-after-save nil))

(use-package merlin-eldoc
  :hook ((tuareg-mode) . merlin-eldoc-setup))

;; This uses Merlin internally
(use-package flycheck-ocaml
  :config
  (flycheck-ocaml-setup))

;;=============================================================== 

(use-package php-mode)


;; ?? 
(use-package cider)

;;ELixirn
(use-package elixir-mode)

;;coq
(use-package company-coq
  :hook
  (coq-mode-hook . company-coq-mode))

;; SLY for Common Lisp
(use-package sly)

;; LSP for Java
(use-package lsp-java
  :config (add-hook 'java-mode-hook 'lsp)
  :bind ("C-c o" . lsp-organize-imports))


(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

;;copiei do github 
;; (use-package helm-lsp)
;; (use-package helm
;;   :config (helm-mode))
 

(use-package quickrun)

;; Lsp tree
(use-package lsp-treemacs)




;; LSP for Python
(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; Pyvenv
(use-package pyvenv
  :after lsp-pyright) 


;; TypeScript support with LSP
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config (setq typescript-indent-level 2))

;;UI enhancements for LSP
(use-package lsp-ui
  :hook ((lsp-mode . lsp-ui-mode))
  :config
  (setq lsp-ui-sideline-update-mode 'line))

  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point) ;; top, bottom, at-point
  (setq lsp-ui-doc-delay 0.4)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-show-with-mouse t)

(use-package lsp-ivy)

;;===============================================================
;; Additional Tools

;; Keybinding helper
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))

;; ;; Terminal
(use-package vterm)
(use-package vterm-toggle
  :bind ("C-c t" . 'vterm-toggle)
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 ;;(display-buffer-reuse-window display-buffer-in-direction)
                 ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                 ;;(direction . bottom)
                 ;;(dedicated . t) ;dedicated is supported in emacs27
                 (reusable-frames . visible)
                 (window-height . 0.3))))

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
	 ("C-M-<"   . mc/skip-to-previous-lik-this)
	 ("C-M->"   . mc/skip-to-next-like-this)))

;; To read PDF
(use-package pdf-tools)

;; To open apps in emacs
;; (use-package app-launcher
;;   :straight '(app-launcher :host github :repo "SebastienWae/app-launcher"))

;; Rainbow parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(advice-add 'rainbow-turn-on :after  #'solo-jazz-theme-rainbow-turn-on)

;; Project management
(use-package projectile
  :config
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/diversao/" "~/")))


(setq projectile-completion-system 'ivy)
;; File tree view
(use-package neotree
  :bind (("C-\\" . neotree-toggle))
  :config
  (setq neo-theme 'icons
        neo-autorefresh t
        neo-show-hidden-files t))
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
   ("C-c d" . helpful-at-point)))

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
  :init (all-the-icoNs-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

;; Icons in dired-mode 
(use-package nerd-icons-dired
  :hook (dired-mode . (lambda () (nerd-icons-dired-mode t))))

;; Use this to preview in dired
(use-package peep-dired
  :after dired
  :config (setq peep-dired-cleanup-on-disable t))

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
  (dashboard-mode . centaur-tabs-local-mode)
  (vterm-mode . centaur-tabs-local-mode))

;;===============================================================
;; ;; Org Mode and Enhancements
;; (use-package org)

;; ;; Pretty org mode with org-superstar
;; (use-package org-superstar
;;   :hook (org-mode . org-superstar-mode)
;;   :config
;;   (setq org-superstar-special-todo-items t))

;; ;; Custom org emphasis styles
;; (setq org-emphasis-alist
;;       '(("*" (bold :slant italic :weight black))
;;         ("/" (italic :foreground "dark salmon"))
;;         ("_" underline :foreground "cyan")
;;         ("=" (:background "snow1" :foreground "deep slate blue"))
;;         ("~" (:background "PaleGreen1" :foreground "dim gray"))
;;         ("+" (:strike-through nil :foreground "dark orange"))))
;; (setq org-hide-emphasis-markers t)

;; ;; TOC support in org-mode
;; (use-package toc-org)

;; ;;ORG-ROAM unicorn 
;; (use-package org-roam
;;   :custom
;;   (org-roam-directory (file-truename "~/RoamNotes"))
;;   :bind (("C-c n l" . org-roam-buffer-toggle)
;;          ("C-c n f" . org-roam-node-find)
;;          ("C-c n g" . org-roam-graph)
;;          ("C-c n i" . org-roam-node-insert)
;;          ("C-c n c" . org-roam-capture)
;;          ;; Dailies
;;          ("C-c n j" . org-roam-dailies-capture-today))
;;   :config
;;   ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;   (org-roam-db-autosync-mode)
;;   ;; If using org-roam-protocol
;;   (require 'org-roam-protocol))
