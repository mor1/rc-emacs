;; Copyright (C) 2000--2021 Richard Mortier <mort@cantab.net> except where
;; noted. All Rights Reserved.
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

;; time emacs startup; updated to new (current-time)
;;  http://a-nickels-worth.blogspot.co.uk/2007/11/effective-emacs.html

;;; Code:

(defconst emacs-start-time (current-time))

(setq gc-cons-threshold 64000000)
(add-hook 'after-init-hook
  #'(lambda ()
      (setq gc-cons-threshold 800000)) ; restore after startup
  )

;; package management
;; per http://cachestocaches.com/2015/8/getting-started-use-package/
(require 'package)
(setq
  gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"
  package-enable-at-startup nil
  package-archives '(("melpa" . "https://melpa.org/packages/")
                      ("gnu" . "https://elpa.gnu.org/packages/")
                      )
  )
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  )

(eval-when-compile
  (require 'use-package))
(require 'diminish) ;; if you use :diminish
(require 'bind-key) ;; if you use any :bind variant

;; debugging; eg `open /Applications/Emacs.app --args --debug-init`
(if init-file-debug
  (progn
    (message "DEBUGGING ON")
    (setq
      use-package-verbose t
      use-package-expand-minimally nil
      use-package-compute-statistics t
      debug-on-error t)
    )
  (setq
    use-package-verbose nil
    use-package-expand-minimally t)
  )

;; server
(load "server")
(setq server-socket-dir (format "/tmp/emacs-%s" (user-login-name)))
(unless (server-running-p) (server-start))

;; codings
(prefer-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-language-environment "utf-8")

;; scrolling
(setq
  scroll-conservatively 101
  scroll-preserve-screen-position t
  scroll-step 1
  scroll-step 1
  scroll-conservatively 10000
  auto-window-vscroll nil
  )

;; reverting buffers
(global-auto-revert-mode t)

;;
;; packages
;;

(use-package auto-compile
  :init
  (setq
    auto-compile-display-buffer nil
    auto-compile-mode-line-counter t
    ))
(auto-compile-on-load-mode)

(use-package calendar
  :config
  (setq
    calendar-bahai-all-holidays-flag nil
    calendar-christian-all-holidays-flag t
    calendar-date-style (quote iso)
    calendar-mark-holidays-flag t
    )
  (calendar-set-date-style 'iso)
  (defun insert-current-date (&optional omit-day-of-week-p)
    (interactive "P*")
    (insert
      (calendar-date-string (calendar-current-date) t omit-day-of-week-p)
      ))
  )

(use-package cc-mode
  :config
  (setq
    c-basic-offset 2
    c-default-style "linux"
    ))

(use-package coffee-mode
  :hook
  ((coffee-mode . coffee-cos-mode))
  :config
  (setq
    coffee-tab-width 2
    ))

(use-package company
  :ensure
  :defer t
  :diminish
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :config
  (setq
    company-dabbrev-other-buffers t
    company-dabbrev-code-other-buffers t
    )
  :hook ((text-mode . company-mode)
          (prog-mode . company-mode)
          )
  :bind (:map company-active-map
          ("C-n". company-select-next)
          ("C-p". company-select-previous)
          ("M-<". company-select-first)
          ("M->". company-select-last))
  )

(use-package css-mode
  :config
  (setq
    css-indent-offset 2
    ))

(use-package csv-mode
  :config
  (setq
    indent-tabs-mode 't
    ))

(use-package dap-mode
  :ensure t
  :defer t
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  )

(use-package direnv
  :config
  (direnv-mode)
  )

(use-package dockerfile-mode
  )

(use-package eldoc
  :diminish
  :hook
  ((c-mode-common emacs-lisp-mode lisp-interaction-mode) . eldoc-mode)
  )

(use-package exec-path-from-shell ;; set exec path
  :config
  (exec-path-from-shell-initialize)
  )

(use-package fill-column-indicator
  :hook
  (prog-mode . fci-mode)
  )

;; (use-package flycheck
;;   ;; flycheck -- on the fly checking
;;   :ensure t
;;   :init
;;   (global-flycheck-mode)
;;   :hook (python-mode . (lambda () (flycheck-mode)))
;;   )

(use-package flyspell
  ;; flyspell -- on the fly spell checking
  :commands (flyspell-prog-mode flyspell-mode)
  :hook
  ((text-mode . flyspell-mode)
    (prog-mode . flyspell-prog-mode)
    )
  :config
  (setq
    ispell-dictionary "british"
    ))

(use-package git-ps1-mode
  :hook find-file
  )

(use-package go-mode
  :hook
  ((before-save . gofmt-before-save)
    (go-mode . go-eldoc-setup)
    )
  :config
  (setq
    gofmt-command "goimports"
    go-eldoc-gocode "/Users/mort/me/external/docker/bin/gocode"
    ))

(use-package ido-completing-read+
  ;; Display possible completions at all places
  :ensure t
  :diminish nil
  :config
  ;; This enables ido in all contexts where it could be useful, not just for
  ;; selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq
    ido-enable-flex-matching t
    ido-use-filename-at-point nil
    ;; Includes buffer names of recently opened files, even if not open now.
    ido-use-virtual-buffers t
    ))

(use-package lisp-mode
  :mode "dune\\'"
  )

(use-package lsp-mode
  :ensure t
  :defer t
  :commands (lsp lsp-deferred)
  :hook
  ((lsp-mode . lsp-ui-mode)
    (python-mode . lsp-deferred))
  :config
  (setq
    lsp-eldoc-render-all t
    lsp-idle-delay 1.0
    lsp-keymap-prefix "C-c l"
    lsp-rust-analyzer-cargo-watch-command "clippy"
    lsp-rust-analyzer-server-display-inlay-hints nil
    ))

(use-package lsp-pyright
  :ensure t
  :defer t
  :config
  (setq
    lsp-pyright-disable-language-services nil
    lsp-pyright-disable-organize-imports nil
    lsp-pyright-auto-import-completions t
    lsp-pyright-use-library-code-for-types t
    )
  :hook
  ((python-mode . (lambda ()
                    (require 'lsp-pyright)
                    (lsp-deferred))
     )))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :bind (:map lsp-ui-mode-map
          ("C-c i" . lsp-ui-imenu))
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq
    lsp-ui-peek-always-show nil
    lsp-ui-sideline-show-hover t
    ;; lsp-ui-doc-enable nil
    lsp-ui-doc-delay 2
    ))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :bind (:map magit-status-mode-map ("q" . magit-quit-session))
  :hook (magit-status-mode . (lambda () (visual-line-mode 0)))
  :config
  (setq
    magit-commit-arguments (quote ("--signoff"))
    magit-diff-refine-hunk (quote all)
    magit-process-popup-time 5
    magit-set-upstream-on-push t
    )
  ;; full screen magit-status
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows)
    )
  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen)
    )
  )

(use-package make-mode
  )

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode
  ( ("\\.md\\'" . markdown-mode)
    ("\\.markdown\\'" . markdown-mode)
    ("README.md\\'" . gfm-mode)
    )
  :magic
  ("\\`==\\+==" . markdown-mode)
  :init
  (setq
    markdown-command "multimarkdown"
    ))

(use-package mu4e
  :config
  (setq
    mu4e-maildir       "~/me/mail" ;; top-level Maildir
    mu4e-sent-folder   "/sent"     ;; folder for sent messages
    mu4e-drafts-folder "/drafts"   ;; unfinished messages
    mu4e-trash-folder  "/trash"    ;; trashed messages
    mu4e-refile-folder "/archive"  ;; saved messages
    ))

;; ocaml

;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

(use-package python
  :ensure t
  :config
  (setq
    python-indent-guess-indent-offset-verbose nil
    python-shell-interpreter "python3"
    ))

(use-package python-mode
  :mode "\\.py\''"
  :custom
  (python-indent-offset 2)
  )

(use-package inferior-python-mode
  :ensure nil
  :hook (inferior-python-mode . hide-mode-line-mode)
  )

(use-package hide-mode-line
  :ensure t
  :defer t
  )

(use-package tuareg
  :init
  (let ((opam-share (ignore-errors
                      (car (process-lines "opam" "config" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      ;; Register Merlin
      (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
      (autoload 'merlin-mode "merlin" nil t nil)
      ;; Use opam switch to lookup ocamlmerlin binary
      (setq merlin-command 'opam)
      ))
  :hook
  (((tuareg-mode caml-mode) . merlin-mode)
    (utop-mode . (lambda ()
                   (local-set-key (kbd "M-<right>") utop-history-goto-next)
                   (local-set-key (kbd "M-<left>") utop-history-goto-prev)
                   )))
  :bind (:map tuareg-mode-map
          ("C-S-<up>" . merlin-type-enclosing-go-up)
          ("C-S-<down>" . merlin-type-enclosing-go-down)
          )
  :mode
  ( ("\\.ml[iylp]?\\'" . tuareg-mode)
    ("\\.fs[ix]?\\'" . tuareg-mode)
    ("i?ocamlinit\\'" . tuareg-mode)
    )
  :config
  (setq
    merlin-use-auto-complete-mode 'easy
    ;; indent-line-function 'ocp-indent-line
    ;; indent-region-function 'ocp-indent-region
    utop-command "opam config exec -- utop -emacs"
    ))

(use-package org-gcal
  :after org
  :defer t
  :hook
  ( (org-agenda-mode . (lambda () (org-gcal-sync)))
    (org-capture-after-finalize . (lambda () (org-gcal-sync)))
    )
  :config
  (setq
    org-gcal-auto-archive nil
    org-gcal-client-id "8131340798-fgd3rln4o8f1uvktvi62mbgdar5usftf.apps.googleusercontent.com"
    org-gcal-client-secret "qYwGpyB9RY8Y37TYO13-myXk"
    org-gcal-file-alist
    '(("o3sbrj8ud1hagvtonj9k9q55vo@group.calendar.google.com" . "~/Dropbox/people/family.org/richard/richard.org")
       ("hiq7rr4gpllhrk84agrg585p357m5qtp@import.calendar.google.com" . "~/Dropbox/people/family.org/richard/tripit.org")
       )
    org-gcal-local-timezone "Europe/London"
    org-gcal-managed-newly-fetched-mode "gcal"
    org-gcal-managed-post-at-point-update-existing 'prompt
    org-gcal-managed-update-existing-mode "org"
    org-gcal-recurring-events-mode 'nested
    ))

(use-package org
  :defer t
  :bind (:map org-mode-map
          ("C-c a" . org-agenda)
          ("<M-S-up>" . org-metaup)
          ("<M-S-down>" . org-metadown)
          )

  :init
  (add-to-list 'file-coding-system-alist '("\\.org\\'" . utf-8-unix))

  :hook
  ((org-agenda-mode
     . (lambda ()
         (local-set-key (kbd "C-x .") 'org-agenda-reschedule-to-today)
         )))

  :config
  (setq
    org-basedir "~/Dropbox/people/family.org/"
    org-agenda-files (mapcar
                       (lambda (f) (expand-file-name f org-basedir))
                       '( "richard/richard.org"
                          "richard/incoming.org"
                          "richard/tripit.org"
                          "zhome/home.org"
                          "zhome/birthdays.org"
                          "angela/angela.org"
                          "eleanor/eleanor.org"
                          "david/david.org"
                          "william/william.org"
                          ))
    revert-without-query (mapcar
                           (lambda (f) (expand-file-name f org-basedir))
                           '("richard/incoming.org"))
    org-agenda-loop-over-headlines-in-active-region nil
    org-agenda-todo-ignore-scheduled 'all
    ;; org-clock-continuously t
    org-adapt-indentation t
    org-hide-leading-stars t
    )

  ;; http://stackoverflow.com/questions/6997387/how-to-archive-all-the-done-tasks-using-a-single-command#6998051
  (defun org-archive-completed-tasks ()
    (interactive)
    (org-map-entries
      (lambda ()
        (org-archive-subtree)
        (setq org-map-continue-from (outline-previous-heading)))
      "/+DONE|+CANCELLED" 'tree)
    )

  ;; use vertical splitting, http://orgmode.org/worg/org-hacks.html
  (defadvice org-prepare-agenda (after org-fix-split)
    (toggle-window-split))
  (ad-activate 'org-prepare-agenda)

  ;; customise my agenda options
  (setq org-agenda-custom-commands
    '(
       ;;        ;; ("a" "Week agenda" ((agenda "" ((org-agenda-span 8)))
       ;;        ;;                      (alltodo ""))
       ;;        ;;   ((org-agenda-compact-blocks t)
       ;;        ;;     (org-agenda-tag-filter-preset '("-kids"))
       ;;        ;;     (org-agenda-include-diary t)
       ;;        ;;     (org-agenda-log-mode-items (quote (closed clock)))
       ;;        ;;     (org-agenda-ndays 7)
       ;;        ;;     (org-agenda-repeating-timestamp-show-all t)
       ;;        ;;     (org-agenda-show-all-dates t)
       ;;        ;;     (org-agenda-skip-deadline-if-done t)
       ;;        ;;     (org-agenda-skip-scheduled-if-done t)
       ;;        ;;     (org-agenda-skip-timestamp-if-done t)
       ;;        ;;     (org-agenda-sorting-strategy '(habit-up time-up deadline-up priority-down todo-state-down))
       ;;        ;;     (org-agenda-start-on-weekday 1)
       ;;        ;;     (org-agenda-time-grid nil)
       ;;        ;;     (org-deadline-warning-days 15)
       ;;        ;;     (org-default-notes-file "~/me/todo/notes.org")
       ;;        ;;     (org-fast-tag-selection-single-key (quote expert))
       ;;        ;;     (org-remember-store-without-prompt t)
       ;;        ;;     ))

       ("a" "Week agenda" agenda ""
         ( (org-agenda-compact-blocks t)
           (org-agenda-include-diary t)
           (org-agenda-log-mode-items (quote (closed clock)))
           (org-agenda-repeating-timestamp-show-all t)
           (org-agenda-skip-deadline-if-done t)
           (org-agenda-skip-scheduled-if-done t)
           (org-agenda-skip-timestamp-if-done t)
           (org-agenda-span 7)
           (org-agenda-start-on-weekday 1)
           (org-deadline-warning-days 15)
           ))

       ("c" "Calendar" agenda ""
         ((org-agenda-span 7)
           (org-agenda-start-on-weekday 1)
           (org-agenda-time-grid nil)
           (org-agenda-repeating-timestamp-show-all t)
           (org-agenda-entry-types '(:timestamp :sexp :scheduled*))
           (org-agenda-category-filter-preset '("-a/nosho"))
           ))

       ("d" "Upcoming deadlines" agenda ""
         ((org-agenda-span 60)
           (org-agenda-time-grid nil)
           (org-deadline-warning-days 365)
           (org-agenda-entry-types '(:deadline))
           ))

       ("m" "Month agenda" ((agenda "" ((org-agenda-span 31))) (alltodo ""))
         ((org-agenda-compact-blocks t)
           (org-agenda-category-filter-preset '("-a/nosho"))
           (org-agenda-include-diary t)
           (org-agenda-log-mode-items (quote (closed clock)))
           (org-agenda-ndays 31)
           (org-agenda-repeating-timestamp-show-all t)
           (org-agenda-show-all-dates t)
           (org-agenda-skip-deadline-if-done t)
           (org-agenda-skip-scheduled-if-done t)
           (org-agenda-skip-timestamp-if-done t)
           (org-agenda-sorting-strategy '(habit-up time-up deadline-up priority-down todo-state-down))
           (org-agenda-start-on-weekday 1)
           (org-agenda-time-grid nil)
           (org-deadline-warning-days 15)
           (org-default-notes-file "~/me/todo/notes.org")
           (org-fast-tag-selection-single-key (quote expert))
           (org-remember-store-without-prompt t)
           ))

       ("n" "Agenda and all TODOs"
         ( (agenda ""
             ((org-agenda-skip-function
                '(org-agenda-skip-entry-if 'REPEATS 'notscheduled)))
             )
           (alltodo "")
           ))

       ("t" "Today"
         ( (agenda ""
             ((org-agenda-span 1)
               ))
           (alltodo "")
           )
         ( (org-agenda-tag-filter-preset '("-kids"))
           (org-agenda-category-filter-preset '("-a/nosho"))
           ))
       ))

  ;; UK bank holiday calculations, <http://www.gnomon.org.uk/diary.html>
  (defun holiday-new-year-bank-holiday ()
    (let ((m displayed-month)
           (y displayed-year))
      (calendar-increment-month m y 1)
      (when (<= m 3)
        (let ((d (calendar-day-of-week (list 1 1 y))))
          (cond ((= d 6)
                  (list (list (list 1 3 y) "New Year's Day Bank Holiday")))
            ((= d 0)
              (list (list (list 1 2 y) "New Year's Day Bank Holiday")))
            )))))

  (defun holiday-christmas-bank-holidays ()
    (let ((m displayed-month)
           (y displayed-year))
      (calendar-increment-month m y -1)
      (when (>= m 10)
        (let ((d (calendar-day-of-week (list 12 25 y))))
          (cond ((= d 5)
                  (list (list (list 12 28 y) "Boxing Day Bank Holiday")))
            ((= d 6)
              (list (list (list 12 27 y) "Boxing Day Bank Holiday")
                (list (list 12 28 y) "Christmas Day Bank Holiday")))
            ((= d 0)
              (list (list (list 12 27 y) "Christmas Day Bank Holiday")))
            )))))

  ;; https://www.reddit.com/r/emacs/comments/5wj76n/orgagendarescheduletotoday/
  (defun org-agenda-reschedule-to-today (&optional arg)
    "Bulk reschedule selected tasks for today."
    (interactive "P")
    (org-agenda-schedule arg ".")
    )

  ;; some Easter related helpers

  (defun da-easter (year)
    "Calculate the date for Easter Sunday in YEAR. Returns the date in the
  Gregorian calendar, ie (MM DD YY) format."
    (let* ((century (1+ (/ year 100)))
            (shifted-epact (% (+ 14 (* 11 (% year 19))
                                (- (/ (* 3 century) 4))
                                (/ (+ 5 (* 8 century)) 25)
                                (* 30 century))
                             30))
            (adjusted-epact (if (or (= shifted-epact 0)
                                  (and (= shifted-epact 1)
                                    (< 10 (% year 19))))
                              (1+ shifted-epact)
                              shifted-epact))
            (paschal-moon (- (calendar-absolute-from-gregorian
                               (list 4 19 year))
                            adjusted-epact)))
      (calendar-dayname-on-or-before 0 (+ paschal-moon 7))))


  (defun da-easter-gregorian (year)
    (calendar-gregorian-from-absolute (da-easter year)))

  (defun calendar-days-from-easter ()
    "When used in a diary sexp, this function will calculate how many days
  are between the current date (DATE) and Easter Sunday."
    (- (calendar-absolute-from-gregorian date)
      (da-easter (calendar-extract-year date))))
  )

(use-package outline
  :diminish outline-minor-mode
  :hook ((emacs-lisp-mode LaTeX-mode) . outline-minor-mode)
  )

(use-package paradox
  :init
  (setq
    paradox-github-token t
    paradox-execute-asynchronously t
    paradox-automatically-star t
    ))

(use-package paren
  :hook (find-file . show-paren-mode)
  :config
  (setq
    show-paren-mode t
    show-paren-style (quote expression)
    ))

(use-package lsp-pyright
  :ensure t
  :hook
  (python-mode . (lambda () (require 'lsp-pyright)))
  :init
  (when (executable-find "python3")
    (setq lsp-pyright-python-executable-cmd "pdm run python3"))
  :config
  (setq
    python-indent-offset 2
    ))

(use-package rainbow-mode
  :hook prog-mode
  )

(use-package recentf
  ;; Recent buffers in a new Emacs session
  :diminish nil
  :config
  (recentf-mode t)
  (setq
    recentf-auto-cleanup 'never
    recentf-max-saved-items 1000
    recentf-save-file (concat user-emacs-directory ".recentf")
    ))

(use-package rjsx-mode
  :mode
  ( ("\\.json\\'" . rjsx-mode)
    ("\\.js\\'" . rjsx-mode)
    )
  :config
  (setq
    js-indent-level 2
    ))

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
          ("M-j" . lsp-ui-imenu)
          ("M-?" . lsp-find-references)
          ("C-c C-c l" . flycheck-list-errors)
          ("C-c C-c a" . lsp-execute-code-action)
          ("C-c C-c r" . lsp-rename)
          ("C-c C-c q" . lsp-workspace-restart)
          ("C-c C-c Q" . lsp-workspace-shutdown)
          ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq
    rustic-format-on-save t
    ))

(use-package saveplace ;; save cursor position in file after close
  :unless noninteractive
  :config (save-place-mode t)
  )

(use-package sh-script
  :mode
  ( ("bash_" . sh-mode)
    ( "APKBUILD\\'" . sh-mode)
    )
  :config
  (setq
    sh-basic-offset 2
    sh-indentation 2
    ))

(use-package solarized-theme
  :ensure
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
      (message "%S" (car theme-current)))
    )

  :bind
  ("C-c t" . my-theme-cycle)
  :hook
  (after-init . (lambda () (load-theme 'solarized-dark)))
  )

(use-package subword ;; subword -- obey CamelCase etc
  :config
  (setq
    global-subword-mode t
    ))

(use-package tex
  :ensure auctex
  :mode
  ( ("\\.tex\\'" . TeX-latex-mode)
    ("\\.latex\\'" . TeX-latex-mode)
    ("\\.bibtex\\'" . bibtex-mode)
    )
  :hook
  ((LaTeX-mode . LaTeX-math-mode)
    (LaTeX-mode . turn-on-reftex)
    )
  :config
  (use-package latex)
  (setq
    bibtex-dialect 'biblatex
    TeX-auto-save t
    TeX-parse-self t
    TeX-master t
    reftex-plug-into-AUCTeX t
    )

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
      (if (and (eq start oldpoint)
            (eq end oldpoint))
        ;; insert the command as nothing to enclose
        (progn (insert before) (insert after) (backward-char))

        ;; enclose the word with the command
        (progn
          (insert after)
          (goto-char start)
          (insert before)
          (goto-char (+ oldpoint (length before)))
          )
        )))

  :bind (:map LaTeX-mode-map
          ("{" . TeX-insert-braces)
          ( "M-[" . (lambda () (interactive) (insert "{")))
          ( "M-]" . (lambda () (interactive) (insert "}")))
          ( "C-c m" . (lambda () (interactive "*")
                        (tex-enclose-word "\\emph{" "}")))
          ( "C-c b" . (lambda () (interactive "*")
                        (tex-enclose-word "\\textbf{" "}")))
          )
  )

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq
    typescript-indent-level 2
    ))

(use-package web-mode
  :mode
  ( ("\\.html\\'" . web-mode)
    ("\\.css\\'" . web-mode)
    )
  :magic
  ("\\`<\\?xml" . web-mode)
  :config
  (setq
    web-mode-markup-indent-offset 2
    web-mode-code-indent-offset 2
    web-mode-css-indent-offset 2
    web-mode-sql-indent-offset 2
    web-mode-enable-current-column-highlight t
    web-mode-enable-current-element-highlight t
    )
  (set (make-local-variable 'company-backends)
    '(company-css company-web-html company-yasnippet company-files)
    ))

(use-package visual-fill-column
  :hook (text-mode . visual-fill-column-mode)
  )

(use-package whitespace
  ;; whitespace <https://github.com/jwiegley/dot-emacs/blob/master/init.el>
  :commands (whitespace-buffer
              whitespace-cleanup
              whitespace-mode
              whitespace-turn-off)
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
        (save-buffer))
      ))

  (defun maybe-turn-on-whitespace ()
    (when (not (locate-dominating-file default-directory ".noclean"))
      (progn
        (setq whitespace-style
          '(face trailing tabs lines-tail newline empty space-before-tab tab-mark))
        (whitespace-mode t)
        )))

  :hook
  ( (find-file . maybe-turn-on-whitespace)
    (prog-mode . whitespace-cleanup)
    ))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  )

;;
;; functions
;;

;; http://whattheemacsd.com/
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
    (progn
      (linum-mode 1)
      (goto-line (read-number "Goto line: "))
      )
    (linum-mode -1)
    ))
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun line-to-top-of-window ()    (interactive) (recenter 0))
(defun line-to-bottom-of-window () (interactive) (recenter -1))
(defun warp-to-top-of-window ()    (interactive) (move-to-window-line 0))
(defun warp-to-bottom-of-window () (interactive) (move-to-window-line -1))

(defun reread-dot-emacs ()
  "Re-read initialisation."
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )

(defun match-paren (arg)
  "Go to matching parenthesis if one exists, otherwise insert ARG(=1) %s."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
    ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t (self-insert-command (or arg 1))))
  )

(defun my-kill-emacs ()
  "Confirm before 'save-buffers-kill-emacs'."
  (interactive)
  (if (y-or-n-p "Really kill Emacs? ")
    (save-buffers-kill-emacs)
    (message "Aborted"))
  )

(defun my-suspend-frame ()
  "Confirm before suspend Emacs."
  (interactive)
  (if (y-or-n-p "Really minimise? ")
    (suspend-frame)
    (message "Aborted"))
  )

(defun todo ()  (interactive) (find-file "~/Dropbox/people/family.org/richard/richard.org"))
(defun notes () (interactive) (find-file "~/me/todo/notes.org"))

;;
;; mode hooks
;;

;; (require 'filladapt)                    ; not a package :(
;; (add-hook 'text-mode-hook '(lambda () (filladapt-mode t)))

;;
;; keybindings
;;

(bind-keys*
  ("%"          . match-paren)
  ("C-<return>" . split-line)
  ("C-<tab>"    . dabbrev-expand)
  ("C-c ;"      . comment-region)
  ("C-c C-SPC"  . whitespace-cleanup)
  ("C-c C-g"    . goto-line)
  ("C-x C-c"    . my-kill-emacs)
  ("C-x C-d"    . insert-current-date)
  ("C-x C-z"    . my-suspend-frame)
  ("C-x p"      . (lambda () (interactive) (other-window -1)))
  ("C-x z"      . my-suspend-frame)
  ("C-z"        . my-suspend-frame)
  ("M-%"        . replace-regexp)
  ("M-n"        . next-buffer)
  ("M-p"        . previous-buffer)
  ("M-q"        . unfill-toggle)

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
  ("C-<up>"     . backward-paragraph)
  ("C-<down>"   . forward-paragraph)
  ("M-<up>"     . warp-to-top-of-window)
  ("M-<down>"   . warp-to-bottom-of-window)
  ("C-M-<down>" . line-to-top-of-window)
  ("C-M-<up>"   . line-to-bottom-of-window)

  ;; for a sensible pc keyboard with pgup|pgdn|home|end
  ("C-<prior>" . warp-to-top-of-window)
  ("C-<next>"  . warp-to-bottom-of-window)
  ("C-<home>"  . line-to-top-of-window)
  ("C-<end>"   . line-to-bottom-of-window)
  ("<home>"    . beginning-of-buffer)    ; M-<
  ("<end>"     . end-of-buffer)          ; M->
  )

;; Horizontal scrolling mouse events should actually scroll left and right.
(global-set-key (kbd "<mouse-6>")
  (lambda () (interactive) (if truncate-lines (scroll-right 1)))
  )
(global-set-key (kbd "<mouse-7>")
  (lambda () (interactive) (if truncate-lines (scroll-left 1)))
  )

;;
;; load customisations
;;

(setq custom-file "~/.emacs.d/init-custom.el")
(load custom-file)
(put 'narrow-to-region 'disabled nil)

;;
;; ...and we're done
;;

(let ((elapsed (float-time (time-subtract (current-time)
                             emacs-start-time))))
  (message "Loading %s...done (%.3fs)" load-file-name elapsed))

(add-hook
  'after-init-hook
  `(lambda ()
     (let ((elapsed
             (float-time
               (time-subtract (current-time) emacs-start-time))))
       (message "Loading %s...done (%.3fs) [after-init]"
         ,load-file-name elapsed)))
  t)
(put 'scroll-left 'disabled nil)
