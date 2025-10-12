;;; init.el -- mort's emacs initialisation  -*- lexical-binding: t -*-

;;; Commentary:

;; Copyright (C) Richard Mortier <mort@cantab.net> except where noted. All
;; Rights Reserved.
;;
;; Permission to use, copy, modify, and distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;; SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
;; IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;;; Code:

(defconst emacs-start-time (current-time))

;; ;; quelpa
;; (unless (package-installed-p 'quelpa)
;;   (with-temp-buffer
;;     (url-insert-file-contents
;;      "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
;;     (eval-buffer)
;;     (quelpa-self-upgrade)))

;; ;; straight
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name
;;         "straight/repos/straight.el/bootstrap.el"
;;         (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
;;       (bootstrap-version 7))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent
;;          'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))
;; (straight-use-package 'use-package)

;; package management
(require 'package)
(require 'use-package-ensure)
(use-package package
  :ensure nil
  :config (package-initialize)
  :custom
  (package-enable-at-startup nil)
  (package-native-compile t)
  (package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/"))))

;; debugging
(if init-file-debug
    (progn
      (message "DEBUGGING ON")
      (setq
       use-package-compute-statistics t
       use-package-expand-minimally nil
       use-package-verbose t
       debug-on-error t))
  (setq
   use-package-always-defer t
   use-package-always-demand nil
   use-package-always-ensure t
   use-package-enable-imenu-support t
   use-package-expand-minimally t
   use-package-verbose nil))

;; server
(load "server")
(setq server-socket-dir (format "/tmp/emacs-%s" (user-login-name)))
(unless (server-running-p)
  (server-start))

;;
;; packages
;;

(use-package emacs
  :init
  ;; codings
  (prefer-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (set-clipboard-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-file-name-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment "utf-8")
  (set-selection-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)

  (global-auto-revert-mode t)
  (global-hl-line-mode t)
  (global-visual-line-mode t)

  (add-to-list 'interpreter-mode-alist '("uv" . python-mode))
  (put 'narrow-to-region 'disabled nil)

  :custom
  (auto-hscroll-mode 'current-line)
  (auto-window-vscroll nil)

  (bibtex-autokey-titleword-separator ".")
  (bibtex-autokey-year-title-separator ":")

  (column-number-mode t)
  (comment-auto-fill-only-comments t)
  (context-menu-mode t)
  (custom-safe-themes
   '("7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
     default))
  (default-major-mode 'text-mode t)
  (display-time-day-and-date t)
  (enable-recursive-minibuffers t)
  (epg-pinentry-mode 'loopback)
  (fill-column 80)
  (frame-title-format "%b  %f" t)
  (indent-tabs-mode nil)
  (inhibit-startup-screen t)
  (initial-frame-alist '((top . 1) (left . 1) (width . 170) (height . 80)))
  (interprogram-paste-function 'x-selection-value t)
  (lisp-indent-offset 2)
  (make-backup-files nil)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  (mouse-buffer-menu-mode-mult 1)
  (next-screen-context-lines 0)
  (ns-alternate-modifier 'none)
  (ns-command-modifier 'meta)
  (ns-function-modifier 'hyper)
  (package-selected-packages nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (require-final-newline 'visit-save)

  (scroll-bar-mode nil)
  (scroll-conservatively 10000)
  (scroll-preserve-screen-position t)
  (scroll-step 1)

  (sentence-end-double-space nil)
  (size-indication-mode t)
  (tab-width 4)
  (uniquify-buffer-name-style 'post-forward-angle-brackets nil (uniquify))
  (unkillable-scratch t)
  (vc-follow-symlinks t)
  (visible-bell t)
  (visual-line-fringe-indicators '(right-triangle right-curly-arrow))
  (whitespace-line-column nil))

(use-package auto-compile
  :custom
  (auto-compile-display-buffer nil)
  (auto-compile-mode-line-counter t))
(auto-compile-on-load-mode)

(use-package avy)

(use-package calendar
  :custom
  (calendar-bahai-all-holidays-flag nil)
  (calendar-christian-all-holidays-flag t)
  (calendar-date-style (quote iso))
  (calendar-mark-holidays-flag t)
  :config
  (calendar-set-date-style 'iso)
  (defun insert-current-date (&optional omit-day-of-week-p)
    (interactive "P*")
    (insert
     (calendar-date-string (calendar-current-date) t omit-day-of-week-p))))

(use-package dabbrev
  ;; dynamic abbreviations from buffer
  :bind (("M-/" . dabbrev-completion) ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(use-package cc-mode
  :custom
  (c-basic-offset 2)
  (c-default-style "linux"))

(use-package diff-hl
  :init (global-diff-hl-mode))

;; CLI environments
(use-package direnv)
(use-package inheritenv)
;;

(use-package dirvish
  :custom
  (dirvish-bookmarks-alist
   '(("h" "~/" "Home") ("d" "~/Downloads/" "Downloads") ("m" "/mnt/" "Drives")))
  (dirvish-attributes '(all-the-icons file-size))
  :config
  (dirvish-override-dired-mode)
  (dirvish-peek-mode)
  :bind
  (:map
   dired-mode-map
   ("SPC" . dirvish-show-history)
   ("r" . dirvish-roam)
   ("b" . dirvish-goto-bookmark)
   ("f" . dirvish-file-info-menu)
   ("M-a" . dirvish-mark-actions-menu)
   ("M-s" . dirvish-setup-menu)
   ("M-f" . dirvish-toggle-fullscreen)
   ([remap dired-summary] . dirvish-dispatch)
   ([remap dired-do-copy] . dirvish-yank)
   ([remap mode-line-other-buffer] . dirvish-other-buffer)))

(use-package dockerfile-ts-mode
  :mode
  (("\\Dockerfile\\'" . dockerfile-ts-mode)
   ("\\.dockerignore\\'" . dockerfile-ts-mode)))

(use-package shfmt
  :hook ((sh-mode . shfmt-on-save-mode) (bash-ts-mode . shfmt-on-save-mode))
  :custom
  (sh-basic-offset 2)
  (sh-indendentation 2)
  (shfmt-respect-sh-basic-offset t)
  (shfmt-arguments
   '("--simplify" "--binary-next-line" "--case-indent" "--space-redirects")))

;; LSP support
(use-package eglot
  ;; per https://justinbarclay.ca/posts/from-zero-to-ide-with-emacs-and-lsp/
  :config
  (setq-default eglot-workspace-configuration
                '((:pylsp
                   .
                   (:plugins
                    (:basedpyright
                     ()
                     :basedpyright.analysis
                     (:typeCheckingMode
                      "recommended"
                      :autoImportCompletions t
                      ;; :inlayHints
                      ;; (:variableTypes
                      ;;  t
                      ;;  :callArgumentNames t
                      ;;  :functionReturnTypes t
                      ;;  :genericTypes t)
                      ))))))

  ;; :custom
  ;; (eglot-ignored-server-capabilities
  ;;  '(:hoverProvider
  ;;    :documentHighlightProvider
  ;;    :documentFormattingProvider
  ;;    :documentRangeFormattingProvider
  ;;    :documentOnTypeFormattingProvider
  ;;    :colorProvider
  ;;    :foldingRangeProvider))
  :hook
  (eglot-managed-mode . eglot-inlay-hints-mode)
  (sh-mode . eglot-ensure)
  (bash-ts-mode . eglot-ensure)
  :bind
  (:map
   eglot-mode-map
   ("C-c c a" . eglot-code-actions)
   ("C-c c o" . eglot-code-actions-organize-imports)
   ("C-c c r" . eglot-rename)
   ("C-c c f" . eglot-format)))
(use-package eglot-booster
  :vc (:url "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode))
(use-package emacs
  :after eglot
  :config
  (add-to-list
   'eglot-server-programs
   '((sh-mode bash-ts-mode) . ("bash-language-server" "start"))))
;;

(use-package eldoc
  :init (global-eldoc-mode))

(use-package elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode))

(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

(use-package fill-column-indicator
  :hook (prog-mode . fci-mode)
  :custom (fci-rule-width 2))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-eglot
  :after (flycheck eglot)
  :config (global-flycheck-eglot-mode 1))

(use-package gcmh
  :config (gcmh-mode 1))

(use-package git-ps1-mode
  :hook find-file)

(use-package ido-completing-read+
  ;; display possible completions at all places
  :config
  (ido-mode t)
  (ido-everywhere t)
  (setq
   ido-enable-flex-matching t
   ido-use-filename-at-point nil
   ido-use-virtual-buffers t))
(use-package hide-mode-line)

(use-package jinx
  :diminish
  :hook (emacs-startup . global-jinx-mode)
  :bind (("C-;" . jinx-correct) ("C-M-$" . jinx-languages))
  ;; :config
  ;; (vertico-multiform-mode)
  ;; (add-to-list
  ;;  'vertico-multiform-categories
  ;;  '(jinx grid (vertico-grid-annotate . 20) (vertico-count . 4)))
  )

(use-package just-mode)

(use-package magit
  :bind ("C-x g" . magit-status)
  :bind (:map magit-status-mode-map ("q" . magit-quit-session))
  :hook (magit-status-mode . (lambda () (visual-line-mode 0)))
  :custom
  (magit-commit-arguments (quote ("--signoff")))
  (magit-diff-refine-hunk (quote all))
  (magit-process-popup-time 5)
  (magit-set-upstream-on-push t)
  :config
  ;; full screen magit-status
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen)))

(use-package make-mode)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode
  (("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode)
   ("README.md\\'" . gfm-mode))
  :magic ("\\`==\\+==" . markdown-mode)
  :custom (markdown-command "multimarkdown"))

(use-package mu4e
  :custom
  (mu4e-attachment-dir "~/Downloads")
  (mu4e-compose-complete-only-personal t)
  (mu4e-confirm-quit nil)

  (mu4e-date-format-long "%FT%T%z")
  (mu4e-headers-long-date-format "%F%FT%z")
  (mu4e-headers-time-format "%F%FT%z")

  (mu4e-drafts-folder "/drafts") ;; unfinished messages
  (mu4e-maildir "~/u/me/mail") ;; top-level Maildir
  (mu4e-mu-binary (executable-find "mu"))
  (mu4e-refile-folder "/archive") ;; saved messages
  (mu4e-sent-folder "/sent") ;; folder for sent messages
  (mu4e-trash-folder "/trash") ;; trashed messages

  (mu4e-update-interval nil)
  (mu4e-use-fancy-chars t)
  (mu4e-user-mail-address-list
   '("mort@cantab.net"
     "mort@live.co.uk"
     "mort@microsoft.com"
     "mort@sprintlabs.com"
     "mort@vipadia.com"
     "richard.mortier@cl.cam.ac.uk"
     "richard.mortier@gmail.com"
     "richard.mortier@hotmail.com"
     "richard.mortier@nottingham.ac.uk"
     "richard.mortier@unikernel.com"
     "rmm1002@cam.ac.uk"
     "rmm1002@hermes.cam.ac.uk"
     "rmm@cs.nott.ac.uk"))
  (mu4e-view-show-addresses t)
  (mu4e-view-show-images t))

;; Nix
(use-package nixfmt
  :hook (nix-ts-mode . nixfmt-on-save-mode))
(use-package nix-ts-mode
  :mode "\\.nix\\'")
;;

;; OCaml
(use-package neocaml
  :vc (:url "https://github.com/bbatsov/neocaml" :rev :newest)
  :after eglot
  :hook (neocaml-mode . neocaml-repl-minor-mode)
  :config
  (add-to-list
   'eglot-server-programs '((neocaml-mode :language-id "ocaml") . ("ocamllsp")))

  :custom
  (neocaml-repl-program-name "utop")
  (neocaml-repl-program-args '("-emacs"))
  (neocaml-use-prettify-symbols t))
(use-package tuareg
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))
(use-package ocaml-eglot
  :after tuareg
  :hook
  (tuareg-mode . ocaml-eglot)
  (ocaml-eglot . eglot-ensure)
  (ocaml-eglot . (lambda () (add-hook #'before-save-hook #'eglot-format nil t)))
  (eglot-managed-mode . (lambda () (flycheck-eglot-mode 1)))
  :config (setq ocaml-eglot-syntax-checker 'flycheck))
(use-package dune)
(use-package opam-switch-mode
  :after tuareg
  :hook (tuareg-mode . opam-switch-mode))
(use-package ocp-indent
  :after ocaml-eglot
  :hook (ocaml-eglot . ocp-setup-indent))
;;

(use-package org
  :bind
  (:map
   org-mode-map
   ("C-c a" . org-agenda)
   ("<M-S-up>" . org-metaup)
   ("<M-S-down>" . org-metadown))

  :hook
  ((org-agenda-mode
    .
    (lambda () (local-set-key (kbd "C-x .") 'org-agenda-reschedule-to-today))))

  :config
  ;; http://stackoverflow.com/questions/6997387/how-to-archive-all-the-done-tasks-using-a-single-command#6998051
  (defun org-archive-completed-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (outline-previous-heading)))
     "/+DONE|+CANCELLED" 'tree))

  ;; use vertical splitting, http://orgmode.org/worg/org-hacks.html
  (defadvice org-prepare-agenda (after org-fix-split)
    (toggle-window-split))
  (ad-activate 'org-prepare-agenda)

  ;; UK bank holiday calculations, <http://www.gnomon.org.uk/diary.html>
  (defun holiday-new-year-bank-holiday ()
    (let ((m displayed-month)
          (y displayed-year))
      (calendar-increment-month m y 1)
      (when (<= m 3)
        (let ((d (calendar-day-of-week (list 1 1 y))))
          (cond
           ((= d 6)
            (list (list (list 1 3 y) "New Year's Day Bank Holiday")))
           ((= d 0)
            (list (list (list 1 2 y) "New Year's Day Bank Holiday"))))))))

  (defun holiday-christmas-bank-holidays ()
    (let ((m displayed-month)
          (y displayed-year))
      (calendar-increment-month m y -1)
      (when (>= m 10)
        (let ((d (calendar-day-of-week (list 12 25 y))))
          (cond
           ((= d 5)
            (list (list (list 12 28 y) "Boxing Day Bank Holiday")))
           ((= d 6)
            (list
             (list (list 12 27 y) "Boxing Day Bank Holiday")
             (list (list 12 28 y) "Christmas Day Bank Holiday")))
           ((= d 0)
            (list (list (list 12 27 y) "Christmas Day Bank Holiday"))))))))

  ;; https://www.reddit.com/r/emacs/comments/5wj76n/orgagendarescheduletotoday/
  (defun org-agenda-reschedule-to-today (&optional arg)
    "Bulk reschedule selected tasks for today."
    (interactive "P")
    (org-agenda-schedule arg "."))

  ;; some Easter related helpers
  (defun da-easter (year)
    "Calculate the date for Easter Sunday in YEAR. Returns the date in the
  Gregorian calendar, ie (MM DD YY) format."
    (let* ((century (1+ (/ year 100)))
           (shifted-epact
            (% (+ 14 (* 11 (% year 19))
                  (- (/ (* 3 century) 4))
                  (/ (+ 5 (* 8 century)) 25)
                  (* 30 century))
               30))
           (adjusted-epact
            (if (or (= shifted-epact 0)
                    (and (= shifted-epact 1) (< 10 (% year 19))))
                (1+ shifted-epact)
              shifted-epact))
           (paschal-moon
            (- (calendar-absolute-from-gregorian (list 4 19 year))
               adjusted-epact)))
      (calendar-dayname-on-or-before 0 (+ paschal-moon 7))))

  (defun calendar-days-from-easter ()
    "When used in a diary sexp, this function will calculate how many days
  are between the current date (DATE) and Easter Sunday."
    (- (calendar-absolute-from-gregorian date)
       (da-easter (calendar-extract-year date))))

  ;; Now we can schedule the public holidays associated with Easter as recurring
  ;; events. Good Friday is 2 days before "Easter", Easter Monday is one day
  ;; after.

  ;; *** Good Friday
  ;; <%%(= -2 (calendar-days-from-easter))>

  :custom
  (org-adapt-indentation t)
  (org-agenda-files "~/Dropbox/calendar/index")
  (org-agenda-loop-over-headlines-in-active-region nil)
  (org-agenda-todo-ignore-scheduled 'all)
  (org-basedir "~/Dropbox/calendar/")
  (org-hide-leading-stars t)

  (revert-without-query
   (mapcar
    (lambda (f) (expand-file-name f org-basedir))
    '("richard-incoming.org" "richard-tripit.org")))

  (holiday-bahai-holidays nil)
  (holiday-general-holidays
   ((holiday-fixed 1 1 "New Year's Day")
    (holiday-new-year-bank-holiday)
    (holiday-fixed 2 14 "Valentine's Day")
    (holiday-fixed 3 17 "St. Patrick's Day")
    (holiday-fixed 4 1 "April Fools' Day")
    (holiday-easter-etc -21 "Mothering Sunday")
    (holiday-easter-etc 1 "Easter Monday")
    (holiday-float 5 1 1 "Early May Bank Holiday")
    (holiday-float 5 1 -1 "Spring Bank Holiday")
    (holiday-float 6 0 3 "Father's Day")
    (holiday-float 8 1 -1 "Summer Bank Holiday")
    (holiday-fixed 10 31 "Halloween")
    (holiday-fixed 12 24 "Christmas Eve")
    (holiday-fixed 12 26 "Boxing Day")
    (holiday-christmas-bank-holidays)
    (holiday-fixed 12 31 "New Year's Eve")))
  (holiday-hebrew-holidays nil)
  (holiday-islamic-holidays nil)
  (holiday-oriental-holidays nil)
  (holiday-other-holidays
   ((holiday-float 1 1 3 "Martin Luther King Day")
    (holiday-float 2 1 3 "President's Day")
    (holiday-float 5 1 -1 "Memorial Day")
    (holiday-fixed 7 4 "Independence Day")
    (holiday-float 9 1 1 "Labor Day")
    (holiday-float 10 1 2 "Columbus Day")
    (holiday-fixed 11 11 "Veteran's Day")
    (holiday-float 11 4 4 "Thanksgiving")))
  (org-agenda-custom-commands
   '(("a" "Week agenda" agenda ""
      ((org-agenda-compact-blocks t)
       (org-agenda-include-diary t)
       (org-agenda-log-mode-items (quote (closed clock)))
       (org-agenda-repeating-timestamp-show-all t)
       (org-agenda-skip-deadline-if-done t)
       (org-agenda-skip-scheduled-if-done t)
       (org-agenda-skip-timestamp-if-done t)
       (org-agenda-span 7)
       (org-agenda-start-on-weekday 1)
       (org-deadline-warning-days 15)))

     ("m" "Month agenda" ((agenda "" ((org-agenda-span 31))) (alltodo ""))
      ((org-agenda-compact-blocks t)
       (org-agenda-category-filter-preset
        '("-a/nosho" "-a/m-taxi")) ;; /-^extension day/
       (org-agenda-include-diary t)
       (org-agenda-log-mode-items (quote (closed clock)))
       (org-agenda-ndays 31)
       (org-agenda-repeating-timestamp-show-all t)
       (org-agenda-show-all-dates t)
       (org-agenda-skip-deadline-if-done t)
       (org-agenda-skip-scheduled-if-done t)
       (org-agenda-skip-timestamp-if-done t)
       (org-agenda-sorting-strategy
        '(habit-up time-up deadline-up priority-down todo-state-down))
       (org-agenda-start-on-weekday 1)
       (org-agenda-time-grid nil)
       (org-deadline-warning-days 15)
       (org-default-notes-file "~/me/todo/notes.org")
       (org-fast-tag-selection-single-key (quote expert))
       (org-remember-store-without-prompt t)))

     ("t" "Today"
      ((agenda "" ((org-agenda-span 1)))
       (alltodo
        ""
        ;; ((org-agenda-sorting-strategy '(tag-up)))
        ))
      ((org-agenda-include-diary t))))))

(use-package org-gcal
  :after org
  :hook
  ((org-agenda-mode . (lambda () (org-gcal-sync)))
   (org-capture-after-finalize . (lambda () (org-gcal-sync))))
  :custom
  (plstore-cache-passphrase-for-symmetric-encryption t)
  (org-gcal-auto-archive nil)

   org-gcal-client-id "XXX"
   org-gcal-client-secret "XXX"
   org-gcal-file-alist
   '(("XXX@group.calendar.google.com" . "~/Dropbox/calendar/richard.org")
     ("XXX@import.calendar.google.com"
      .
      "~/Dropbox/calendar/richard-tripit.org"))

  (org-gcal-local-timezone "Europe/London")
  (org-gcal-managed-newly-fetched-mode "gcal")
  (org-gcal-managed-post-at-point-update-existing 'never-push)
  (org-gcal-managed-update-existing-mode "org")
  (org-gcal-recurring-events-mode 'nested))

(use-package outline
  :diminish outline-minor-mode
  :hook ((emacs-lisp-mode LaTeX-mode) . outline-minor-mode))

;; tree-sitters
(use-package tree-sitter-langs
  :after tree-sitter)
(use-package treesit-auto
  :config (global-treesit-auto-mode))
(use-package treesit-fold
  :vc (:url "https://github.com/emacs-tree-sitter/treesit-fold"))
;;

(use-package paren
  :hook (find-file . show-paren-mode)
  :custom
  (show-paren-mode t)
  (show-paren-style (quote expression)))

(use-package rainbow-mode
  :diminish
  :hook prog-mode)

(use-package recentf
  ;; recent buffers in a new Emacs session
  :config (recentf-mode t)
  :custom
  (recentf-auto-cleanup 'never)
  (recentf-max-saved-items 1000)
  (recentf-save-file (concat user-emacs-directory ".recentf")))

(use-package rg
  :init (rg-enable-default-bindings))

(use-package rust-mode
  :custom (rust-mode-treesitter-derive t))
(use-package rustic
  ;; rustup install rust-analyzer; rustup update
  :after (rust-mode)
  :hook (eglot--managed-mode-hook . (lambda () (flymake-mode -1)))
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer"))
  (rustic-lsp-client 'eglot)
  (rustic-format-on-save t)
  (rustic-cargo-use-last-stored-arguments t))

(use-package saveplace
  ;; save cursor position in file after close
  :unless noninteractive
  :config (save-place-mode t))

(use-package solarized-theme
  :init
  (progn
    (defvar my-color-themes (list 'solarized-dark 'solarized-light))
    (defvar theme-current my-color-themes)

    (defun my-theme-set-default ()
      (interactive)
      (setq theme-current my-color-themes)
      (load-theme (car theme-current) t))

    (defun my-describe-theme () ; Show the current theme
      (interactive)
      (message "%s" (car theme-current)))

    (defun my-theme-cycle ()
      (interactive)
      (setq theme-current (cdr theme-current))
      (if (null theme-current)
          (setq theme-current my-color-themes))
      (load-theme (car theme-current) t)
      (message "%S" (car theme-current))))

  :custom
  (solarized-distinct-fringe-background t)
  (solarized-scale-org-headlines nil)
  (solarized-scale-outline-headlines nil)
  (solarized-use-variable-pitch nil)

  :bind ("C-c t" . my-theme-cycle)
  :hook (after-init . (lambda () (load-theme 'solarized-dark))))

(use-package subword
  ;; obey CamelCase etc
  :custom (global-subword-mode t))

(use-package latex
  :ensure auctex
  :mode
  (("\\.tex\\'" . latex-mode)
   ("\\.latex\\'" . latex-mode)
   ("\\.bibtex\\'" . bibtex-mode))
  :hook
  ((LaTeX-mode . LaTeX-math-mode)
   (LaTeX-mode . turn-on-reftex)
   (LaTeX-mode . TeX-fold-mode))
  :config
  (use-package latex)
  (setq
   bibtex-dialect 'biblatex
   TeX-auto-save t
   TeX-parse-self t
   TeX-master t
   reftex-plug-into-AUCTeX t)

  ;; modified from swiftex.el
  (defun tex-enclose-word (before after)
    (interactive "*Mbefore: \nMafter: ")
    (let* ((oldpoint (point))
           (start oldpoint)
           (end oldpoint))

      ;; get the start and end of the current word
      (skip-syntax-backward "w")
      (setq start (point))
      (goto-char oldpoint)
      (skip-syntax-forward "w")
      (setq end (point))
      (if (and (eq start oldpoint) (eq end oldpoint))
          ;; insert the command as nothing to enclose
          (progn
            (insert before)
            (insert after)
            (backward-char))

        ;; enclose the word with the command
        (progn
          (insert after)
          (goto-char start)
          (insert before)
          (goto-char (+ oldpoint (length before)))))))

  :bind
  (:map
   LaTeX-mode-map ("{" . TeX-insert-braces)
   ("M-[" .
    (lambda ()
      (interactive)
      (insert "{")))
   ("M-]" .
    (lambda ()
      (interactive)
      (insert "}")))
   ("C-c m" .
    (lambda ()
      (interactive "*")
      (tex-enclose-word "\\emph{" "}")))
   ("C-c b" .
    (lambda ()
      (interactive "*")
      (tex-enclose-word "\\textbf{" "}")))))
(use-package toml-ts-mode
  :mode "\\.toml\\'")

(use-package typst-ts-mode
  :after eglot
  :mode (("\\.typ\\'" . typst-ts-mode))
  :hook (typst-ts-mode . eglot-ensure)
  :bind ("C-c C-x" . #'typst-ts-tinymist-preview)
  :custom
  (typst-ts-lsp-download-path
   (string-trim (shell-command-to-string "which tinymist")))
  (typst-ts-mode-grammar-location
   (expand-file-name "tree-sitter/libtree-sitter-typst.so"
                     user-emacs-directory))
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  ((keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu)
   (add-to-list
    'eglot-server-programs
    `((typst-ts-mode)
      .
      ,(eglot-alternatives
        `(,typst-ts-lsp-download-path "tinymist" "typst-lsp"))))

   (defun typst-ts-tinymist-preview ()
     "Run `tinymist preview` on the current file."
     (interactive)
     (let ((file (buffer-file-name)))
       (if file
           (compile (format "tinymist preview %s" (shell-quote-argument file)))
         (user-error "Buffer is not visiting a file"))))))

;; interactive menus, minibuffer, completion
(use-package vertico
  :hook
  ((rfn-eshadow-update-overlay . vertico-directory-tidy)
   (minibuffer-setup . vertico-repeat-save))
  :bind
  (:map
   vertico-map
   ("RET" . vertico-directory-enter)
   ("DEL" . vertico-directory-delete-char)
   ("M-DEL" . vertico-directory-delete-word))
  :custom
  (vertico-scroll-margin 0)
  (vertico-count 20)
  (vertico-resize t)
  (vertico-cycle t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  :init (vertico-mode))
(use-package savehist
  :init (savehist-mode))
(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators
   '(marginalia-annotators-heavy marginalia-annotators-light nil))
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init (marginalia-mode))
(use-package nerd-icons-completion
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config (nerd-icons-completion-mode))
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key. `completion-at-point' is
  ;; often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  (treesit-font-lock-level 4))
(use-package corfu
  ;; completion in region popups
  :custom
  (corfu-cycle t) ;; Enable cycling for `corfu-next/previous'
  (corfu-on-exact-match nil) ;; Configure handling of exact matches
  (corfu-preselect 'first) ;; Preselect the prompt
  (corfu-preview-current nil) ;; Disable current candidate preview
  (corfu-quit-at-boundary nil) ;; Never quit at completion boundary
  (corfu-quit-no-match nil) ;; Never quit, even if there is no match

  (corfu-auto t)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (completion-auto-help t)

  :config
  (corfu-history-mode 1)
  (savehist-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-echo-mode)

  :bind
  (:map
   corfu-map
   ("TAB" . corfu-next)
   ([tab] . corfu-next)
   ("S-TAB" . corfu-previous)
   ([backtab] . corfu-previous)))
(use-package corfu-terminal
  :after corfu
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))
(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-blend-background t)
  (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (add-hook
   'my-completion-ui-mode-hook
   (lambda ()
     (setq completion-in-region-function
           (kind-icon-enhance-completion completion-in-region-function)))))
(use-package cape
  :after corfu
  :bind ("C-c c" . cape-prefix-map)
  :init
  ;; (add-hook 'completion-at-point-functions #'cape-dabbrev)
  ;; (add-hook 'completion-at-point-functions #'cape-file)
  ;; (add-hook 'completion-at-point-functions #'cape-elisp-symbol)
  ;; (add-hook 'completion-at-point-functions #'cape-keyword)
  ;; (add-hook 'completion-at-point-functions #'cape-sgml)
  ;; (add-hook 'completion-at-point-functions #'cape-tex)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))
;;

;; web development
(use-package web-mode
  :mode
  (("\\.html?\\'" . web-mode)
   ("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode))

  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-css-colorization t)
  (web-mode-enable-block-face t)
  (web-mode-enable-part-face t)
  (web-mode-enable-current-column-highlight t)
  (web-mode-enable-current-element-highlight t))
(use-package web-mode-edit-element
  :hook (web-mode . web-mode-edit-element-minor-mode))
(use-package com-css-sort
  :commands (com-css-sort com-css-sort-attributes-block com-css-sort-attributes-document)
  :config (setq com-css-sort-sort-type 'alphabetic-sort))
(use-package css-eldoc
  :commands turn-on-css-eldoc
  :hook ((css-mode-hook . turn-on-css-eldoc) (scss-mode-hook . turn-on-css-eldoc)))
;;

(use-package which-key
  :diminish
  :commands (which-key-mode)
  :init (which-key-mode))

(use-package whitespace
  ;; whitespace <https://github.com/jwiegley/dot-emacs/blob/master/init.el>
  :diminish
  :commands (whitespace-buffer whitespace-cleanup whitespace-mode whitespace-turn-off)
  :preface
  (defun normalize-file ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (whitespace-cleanup)
      (delete-trailing-whitespace)
      (goto-char (point-max))
      (delete-blank-lines)
      (set-buffer-file-coding-system 'unix)
      (goto-char (point-min))
      (while (re-search-forward "\r$" nil t)
        (replace-match ""))
      ;; (set-buffer-file-coding-system 'utf-8)
      (let ((require-final-newline t))
        (save-buffer))))

  (defun maybe-turn-on-whitespace ()
    (when (not (locate-dominating-file default-directory ".noclean"))
      (progn
        (setq whitespace-style
              '(face
                trailing
                tabs
                lines-tail
                newline
                empty
                space-before-tab
                tab-mark))
        (whitespace-mode t))))

  :hook ((find-file . maybe-turn-on-whitespace) (prog-mode . whitespace-cleanup)))

(use-package yaml-ts-mode
  :mode "\\.ya?ml\\'")

;; python
(use-package python-mode
  :after (eglot reformatter)
  :hook
  ((python-base-mode . eglot-ensure)
   (python-base-mode . ruff-format-on-save-mode)
   (python-base-mode . dd/ruff-sort-on-save-mode))
  :config
  (add-to-list
   'eglot-server-programs
   `(python-mode
     .
     ,(eglot-alternatives
       '(("basedpyright-langserver" "--stdio") ("ruff" "server")))))
  :preface
  ;; per https://ddavis.io/blog/python-emacs-4/
  (reformatter-define
   dd/ruff-sort
   :program "ruff"
   :args
   `("check" "--select" "I" "--fix" "--stdin-filename" ,buffer-file-name "-")))
(use-package uv-mode
  :after (eglot python-base-mode)
  :hook (python-base-mode . uv-mode-auto-activate-hook))
;;


;;
;; functions
;;

;; http://whattheemacsd.com/
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
      (progn
        (display-line-numbers-mode 1)
        (goto-line (read-number "Goto line: ")))
    (display-line-numbers-mode -1)))
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun line-to-top-of-window ()
  (interactive)
  (recenter 0))
(defun line-to-bottom-of-window ()
  (interactive)
  (recenter -1))
(defun warp-to-top-of-window ()
  (interactive)
  (move-to-window-line 0))
(defun warp-to-bottom-of-window ()
  (interactive)
  (move-to-window-line -1))

(defun reread-dot-emacs ()
  "Re-read initialisation."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(defun match-paren (arg)
  "Go to matching parenthesis if one exists, otherwise insert ARG(=1) %s."
  (interactive "p")
  (cond
   ((looking-at "\\s\(")
    (forward-list 1)
    (backward-char 1))
   ((looking-at "\\s\)")
    (forward-char 1)
    (backward-list 1))
   (t
    (self-insert-command (or arg 1)))))

(defun my-kill-emacs ()
  "Confirm before 'save-buffers-kill-emacs'."
  (interactive)
  (if (y-or-n-p "Really kill Emacs? ")
      (save-buffers-kill-emacs)
    (message "Aborted")))

(defun my-suspend-frame ()
  "Confirm before suspend Emacs."
  (interactive)
  (if (y-or-n-p "Really minimise? ")
      (suspend-frame)
    (message "Aborted")))

(defun todo ()
  (interactive)
  (find-file "~/Dropbox/calendar/richard.org"))
(defun notes ()
  (interactive)
  (find-file "~/u/me/todo/notes.org"))

;;
;; keybindings
;;

(bind-keys*
 ("%" . match-paren)
 ("C-<return>" . split-line)
 ("C-<tab>" . dabbrev-expand)
 ("C-c ;" . comment-region)
 ("C-c C-SPC" . whitespace-cleanup)
 ("C-c C-g" . goto-line)
 ("C-x C-c" . my-kill-emacs)
 ("C-x C-d" . insert-current-date)
 ("C-x C-z" . my-suspend-frame)
 ("C-x p" .
  (lambda ()
    (interactive)
    (other-window -1)))
 ("C-x z" . my-suspend-frame)
 ("C-z" . my-suspend-frame)
 ("M-%" . replace-regexp)
 ("M-n" . next-buffer)
 ("M-p" . previous-buffer)
 ("M-q" . unfill-toggle)

 ;; | point-to  | previous   | next        |
 ;; |-----------+------------+-------------|
 ;; | char      | <left>     | <right>     |
 ;; | word      | C/M-<left> | C/M-<right> |
 ;; | line      | <up>       | <down>      |
 ;; | paragraph | C-<up>     | C-<down>    |

 ;; | point-to | start  | end      |
 ;; |----------+--------+----------|
 ;; | line     | C-a    | C-e      |
 ;; | sentence | M-a    | M-e      |
 ;; | screen   | M-<up> | M-<down> |
 ;; | file     | M-\<   | M-\>     |

 ;; | window-to | key        |
 ;; |-----------+------------|
 ;; | top       | C-M-<down> |
 ;; | bottom    | C-M-<up>   |

 ;; | centre-current |     |
 ;; |----------------+-----|
 ;; | point          | M-r |
 ;; | window         | C-l |

 ;; for poxy macbook keyboard with only the arrow keys
 ("C-<up>" . backward-paragraph)
 ("C-<down>" . forward-paragraph)
 ("M-<up>" . warp-to-top-of-window)
 ("M-<down>" . warp-to-bottom-of-window)
 ("C-M-<down>" . line-to-top-of-window)
 ("C-M-<up>" . line-to-bottom-of-window)

 ;; for a sensible pc keyboard with pgup|pgdn|home|end
 ("C-<prior>" . warp-to-top-of-window)
 ("C-<next>" . warp-to-bottom-of-window)
 ("C-<home>" . line-to-top-of-window)
 ("C-<end>" . line-to-bottom-of-window)
 ("<home>" . beginning-of-buffer) ; M-<
 ("<end>" . end-of-buffer) ; M->
 )

;; Horizontal scrolling mouse events should actually scroll left and right.
(global-set-key
 (kbd "<mouse-6>")
 (lambda ()
   (interactive)
   (if truncate-lines
       (scroll-right 1))))
(global-set-key
 (kbd "<mouse-7>")
 (lambda ()
   (interactive)
   (if truncate-lines
       (scroll-left 1))))

;;
;; load customisations
;;


;;
;; ...and we're done
;;

(add-hook 'after-init-hook
          ; Time Emacs startup; updated to new (current-time)
          ;;  http://a-nickels-worth.blogspot.co.uk/2007/11/effective-emacs.html
          `(lambda ()
             (let ((elapsed
                    (float-time
                     (time-subtract (current-time) emacs-start-time))))
               (message "Loading %s...done (%.3fs) [after-init]"
                        ,load-file-name
                        elapsed)))
          t)
(put 'scroll-left 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default
   ((t
     (:inherit
      unspecified
      :extend unspecified
      :stipple unspecified
      :background unspecified
      :foreground unspecified
      :inverse-video unspecified
      :box unspecified
      :strike-through unspecified
      :overline unspecified
      :underline unspecified
      :slant normal
      :weight regular
      :height 90
      :width normal
      :foundry "PfEd"
      :family "Atkinson Hyperlegible Mono"))))
 '(ediff-current-diff-C ((t (:background "yellow1"))))
 '(flyspell-duplicate ((t (:underline (:color "#b58900" :style wave)))))
 '(flyspell-incorrect
   ((t
     (:background
      "#aa0000"
      :foreground "gray75"
      :underline (:color "#dc322f" :style wave)))))
 '(highlight ((t (:background "dark slate gray"))))
 '(smerge-base ((t (:background "lavender"))))
 '(whitespace-line ((t (:foreground unspecified :underline "OrangeRed3"))))
 '(whitespace-tab ((t (:foreground "burlywood4" :inverse-video t)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auto-compile
     avy
     cape
     com-css-sort
     corfu
     corfu-terminal
     css-eldoc
     diff-hl
     direnv
     dirvish
     dune
     eglot-booster
     elisp-autofmt
     exec-path-from-shell
     fill-column-indicator
     flycheck-eglot
     gcmh
     git-ps1-mode
     hide-mode-line
     inheritenv
     jinx
     just-mode
     kind-icon
     magit
     marginalia
     mu4e
     neocaml
     nerd-icons
     nerd-icons-completion
     nerd-icons-corfu
     nix-ts-mode
     nixfmt
     ocaml-eglot
     ocp-indent
     opam-switch-mode
     org-gcal
     pretty-sha-path
     python-mode
     rainbow-mode
     rg
     rustic
     shfmt
     solarized-theme
     tree-sitter-langs
     treesit-auto
     treesit-fold
     tuareg
     typst-ts-mode
     uv-mode
     vertico
     web-mode-edit-element)
   nil nil "Customized with use-package emacs")
 '(package-vc-selected-packages
   '((treesit-fold :url "https://github.com/emacs-tree-sitter/treesit-fold")
     (neocaml :url "https://github.com/bbatsov/neocaml")
     (eglot-booster :url "https://github.com/jdtsmith/eglot-booster"))))
;; Local variables:
;; elisp-autofmt-load-packages-local: ("use-package" "use-package-core")
;; end:
