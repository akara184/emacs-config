;;(add-to-list 'load-path "~/.emacs.d/")
;;(require '(gcmh-mode 1)

;; config package is customize-group // reminder
;; Disabling package.el
(setq package-enable-at-startup nil)
;;===============================================================
;; Disable useless WARNING
(setq warning-minimum-level :emergency)
;;===============================================================

;; Backup dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))
(setq create-lockfiles nil)


;;; Package Configuration
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





;;To user $PATH configs
(use-package exec-path-from-shell)


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))





;; Automatically debug and bisect your init (.emacs) file!
(use-package bug-hunter)






;;===============================================================
;;; Emacs init file configurations








;; Helper function to open the init file
(defun my-open-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))



;; Keybinding to quickly open the init file
(global-set-key (kbd "C-x C-.") 'my-open-init-file)

;;===============================================================
;;; UI & Theme Configurations





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



;; (straight-use-package
;;   ( :type git :repo "https://github.com/"))




;;(load-theme 'everforest-hard-dark t)



(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard  t))





;; --------------
;; Good themes


;; (straight-use-package
;;  '(everforest-emacs
;;    :type git
;;    :host github
;;    :repo "Theory-of-Everything/everforest-emacs"))
;; (load-theme 'everforest-hard-dark t)


;; (use-package kanagawa-themes
;;   :ensure t
;;   :config
;;   (load-theme 'kanagawa-wave t))

;; (use-package  srcery-theme
;;   :config
;;   (load-theme 'srcery t))

;;(use-package adwaita-dark-theme)        ;; adwaita theme
;;(load-theme 'adwaita-dark t) ;; Load theme

;; cool white theme
;; (use-package solo-jazz-theme
;;   :ensure t
;;   :config
;;   (load-theme 'solo-jazz t))

;; (add-to-list 'default-frame-alist '(alpha-background . 20)) ;; For all frame Transparency


;; --------------




;;Mood-line for better modeline
(use-package  mood-line
  :config (mood-line-mode)
  :custom (mood-line-glyph-alist mood-line-glyphs-fira-code))




;; Set default font
(set-face-attribute 'default nil :font "JetBrainsMono" :height 110)





;; Start Emacs in fullscreen mode
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;===============================================================
;;; Keybinding and Shortcut Configurations

(defalias 'list-buffers 'ibuffer-other-window) ;; ibuffer default C-x C-b




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
;;; Error Checking and Auto-complete

;; Flycheck for syntax checking
(use-package flycheck
  :init  (global-flycheck-mode)
  :config
  (setq flycheck-idle-change-delay 0.5
        flycheck-display-errors-delay nil
        flycheck-highlighting-mode 'symbol
        flycheck-indication-mode 'left-fringe
        flycheck-standard-error-navigation t
        flycheck-deferred-syntax-check nil))

        ;; flycheck-python-flake8-executable "~/.local/bin/flake8"
        ;; flycheck-python-pylint-executable "~/.local/bin/pylint"))


;;flycheck porem em inline feio
;; (use-package flycheck-inline
;;   :hook
;;   (flycheck-mode . flycheck-inline-mode))




;; Company-mode for autocompletion
(use-package company
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





;;Use spaces instead of tabs
(setq-default indent-tabs-mode nil)





;;===============================================================
;;; Development Tools


;;When file changes, it autoupdate 
(global-auto-revert-mode 1)





;; LSP for multiple languanges
(use-package lsp-mode
  :hook (lsp-mode . lsp-enable-which-key-integration)
(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode)))




;;UI enhancements for LSP
(use-package lsp-ui
  :custom
  (lsp-ui-sideline-enable nil)
  :hook ((lsp-mode . lsp-ui-mode)))








;;ivy with lsp
(use-package lsp-ivy)








;;Algumas funcoes do LSP usa helm

(use-package helm-lsp)
(use-package helm
  :config (helm-mode))





;;Debug for multiple languanges
(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))







;; Terminal
(use-package vterm)




(add-hook 'vterm-mode-hook
          (lambda ()
            (setq buffer-face-mode-face '(:height 90))
            (buffer-face-mode)))



(use-package vterm-toggle
  :bind ("C-c t" . 'vterm-toggle)
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.2))))




;;C-Plus-Plus c++
(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)


;;C-Plus-Plus c++
(add-hook 'c++-mode-hook
          (lambda ()
            (defun c-cp ()
              "Insere template básico de C++."
              (interactive)
               (insert "#include <bits/stdc++.h>\nusing namespace std;\n\nint main() {\n ios::sync_with_stdio(0); \n cin.tie(0); \n // solution comes here \n}"))
              (local-set-key (kbd "C-c C-p") 'c-cp)))




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




;;PHP
(use-package php-mode)





;; ??
(use-package cider)





;;Elixir
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
  :bind ("C-c o" . lsp-organize-imports)
  ("C-c c" . lsp-execute-code-action))






;; LSP for Python


(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred




;; (use-package lsp-pyright
;;   :custom (lsp-pyright-langserver-command "basedpyright")
;;   :config
;;   (setq   lsp-keep-workspace-alive nil
;;           lsp-copilot-applicable-fn (lambda (&rest _) nil))
;;   :hook
;;   (((python-ts-mode) . (lambda ()
;;                                       (require 'lsp-pyright)
;;                                       (lsp-deferred)))
;;    (flycheck-mode . (lambda ()
;;                       (when (derived-mode-p 'python-mode 'python-ts-mode)
;;                         (flycheck-add-next-checker 'lsp '(warning . python-flake8))
;;                         (flycheck-add-next-checker 'python-flake8 '(warning . python-pylint))
;;                         (message "Added flycheck checkers."))))))



;; TypeScript support with LSP
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config (setq typescript-indent-level 2))




(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))





;;===============================================================
;;; Additional Tools




;;For window-resize
(use-package windresize
  :bind ("C-c w" . windresize))






;; Keybinding helper
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))


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
  (setq projectile-project-search-path '("~/fun/")
        projectile-switch-project-action 'neotree-projectile-action
	projectile-indexing-method 'alien
	projectile-use-git-grep 1)
  (setq projectile-completion-system 'ivy)

  (projectile-discover-projects-in-search-path))





;;Dashboard configuration
(use-package dashboard
  :config
  (setq dashboard-items '((recents . 3)
                          (projects . 5)))
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-icon-type 'all-the-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (dashboard-setup-startup-hook ))




(setq dashboard-startup-banner "~/.emacs.d/pictures/")





;;FILE TREE VIEW
(use-package neotree
  :bind (("C-\\" . neotree-toggle))
  :config
  (setq neo-theme 'icons
        neo-autorefresh t
        neo-smart-open t
        neo-show-hidden-files t
        neo-smart-open t
        neo-window-fixed-size nil))



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





;;Ivy for better minibuffer completion
;;Ivy configuration
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



(use-package ivy-hydra
  :after ivy)



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



;; Pretty Ivy with icons
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))



(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))



;;better M-x
(use-package amx)





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






;;better markdown
(use-package markdown-mode
  :hook (markdown-mode . lsp)
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do))
  :config
  (require 'lsp-marksman)
  (setq markdown-fontify-code-blocks-natively t))

(custom-set-faces
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.8 :foreground "#A3BE8C" :weight extra-bold))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.4 :foreground "#EBCB8B" :weight extra-bold))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.2 :foreground "#D08770" :weight extra-bold))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.15 :foreground "#BF616A" :weight extra-bold))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.11 :foreground "#b48ead" :weight extra-bold))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.06 :foreground "#5e81ac" :weight extra-bold)))))







;;===============================================================
;;Org Mode and Enhancements
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
        ("_" (underline :foreground "cyan")
        ("~" (:foreground "dim gray"))
        ("=" (:background "snow1" :foreground "deep slate blue"))
        ("+" (:strike-through nil :foreground "dark orange")))))
(setq org-hide-emphasis-markers t)

;; TOC support in org-mode
(use-package toc-org)

;;ORG-ROAM unicorn
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/RoamNotes"))
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
