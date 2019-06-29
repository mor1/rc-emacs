;; Copyright (C) 2000--2018 Richard Mortier <mort@cantab.net> except where
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

;; ;; evaluate locally if behind (eg) nottingham proxy
;; (setq url-proxy-services '(("http" . "proxy.nottingham.ac.uk:8080")))
;; (setq url-proxy-services '(("http" . "wwwcache.cs.nott.ac.uk:3128")))

;;
;; package management
;; per http://cachestocaches.com/2015/8/getting-started-use-package/
;;

(require 'package)
(setq package-enable-at-startup nil
      package-archives
      '(("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/"))
      )
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  )

(eval-when-compile
  (require 'use-package)
  )
(require 'diminish) ;; if you use :diminish
(require 'bind-key) ;; if you use any :bind variant

;; ;; auto-update packages
;; (use-package auto-package-update
;;   :config
;;   (setq auto-package-update-delete-old-versions t)
;;   (setq auto-package-update-hide-results t)
;;   (auto-package-update-maybe)
;;   )

;; debugging; eg `open /Applications/Emacs.app --args --debug-init`
(if init-file-debug
    (progn
      (message "DEBUGGING ON")
      (setq use-package-verbose t
            use-package-expand-minimally nil
            use-package-compute-statistics t
            debug-on-error t)
      )
  (setq use-package-verbose nil
        use-package-expand-minimally t)
  )

;; add homebrew site-lisp directories to the load-path
(let ((default-directory
        (concat user-emacs-directory (convert-standard-filename "elisp/"))))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path)
  )
(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path)
  )

;; server
(load "server")
(setq server-socket-dir (format "/tmp/emacs-%s" (user-login-name)))
(unless (server-running-p) (server-start))

;; fonts
(add-to-list 'default-frame-alist '(font . "Hack 10"))
;;; (set-frame-font "-*-Hack-normal-normal-normal-*-10-*-*-*-m-0-iso10646-1")
;;; (set-frame-font "-*-Hack-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1")
;;; (set-frame-font "-*-Hack-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;;; (set-frame-font "-*-Hack-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;;; (set-frame-font "-*-Hack-normal-normal-normal-*-24-*-*-*-m-0-iso10646-1")

;; input method
(setq default-input-method "TeX")
(set-language-environment "utf-8")
(prefer-coding-system 'utf-8)

;; scrolling
(setq scroll-conservatively 101
      scroll-preserve-screen-position t
      scroll-step 1
      scroll-step 1
      scroll-conservatively 10000
      auto-window-vscroll nil
      )

;;
;; packages
;;

;; aggressive-indent
;; (global-aggressive-indent-mode 1)
;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode)

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode)
  )

(use-package auto-compile
  :init
  (setq auto-compile-display-buffer nil
        auto-compile-mode-line-counter t
        )
  (auto-compile-on-load-mode)
  )

(use-package calendar
  :defer t
  :config
  (setq calendar-bahai-all-holidays-flag nil
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

(use-package coffee-mode
  :config
  (setq coffee-tab-width 2
        ;; coffee-command "/usr/local/bin/coffee" ;; i containerised it...
        )
  :hook (coffee-mode . coffee-cos-mode)
  )

(use-package css-mode
  :mode ("\\.less$")
  )

(use-package csv-mode
  :mode ("\\.tsv$")
  :config (setq indent-tabs-mode 't)
  )

(use-package direnv
  :config (direnv-mode)
  )

(use-package dockerfile-mode
  :mode "Dockerfile"
  )

(use-package eldoc
  :diminish
  :hook ((c-mode-common emacs-lisp-mode lisp-interaction-mode) . eldoc-mode)
  )

(use-package exec-path-from-shell ;; set exec path
  :config
  (exec-path-from-shell-initialize)
  )

(use-package fill-column-indicator
  :hook (prog-mode . fci-mode)
  )

;; flycheck -- on the fly checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

;; flyspell -- on the fly spell checking
(use-package flyspell
  :commands (flyspell-prog-mode flyspell-mode)
  :config
  (setq ispell-dictionary "british")
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)
         )
  ;; :init
  ;; (add-hook 'text-mode-hook 'flyspell-mode)
  ;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  )

(use-package git-ps1-mode
  :hook find-file
  ;; git-ps1-mode-ps1-file
  )

;; git-timemachine

(use-package go-mode
  :hook ((before-save . gofmt-before-save)
         (go-mode . go-eldoc-setup)
         )
  :config
  (setq gofmt-command "goimports"
        go-eldoc-gocode "/Users/mort/me/external/docker/bin/gocode"
        )
  )

(use-package json-mode
  :mode "\\.json$"
  )

(use-package json-reformat
  :after json-mode
  )

(use-package magit
  :config
  (setq magit-commit-arguments (quote ("--signoff"))
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
  :bind (:map magit-status-mode-map ("q" . magit-quit-session))
  :hook (magit-status-mode . (lambda () (visual-line-mode 0)))
  )

(use-package make-mode
  :mode (("sources$" . makefile-mode)
         ("Makefile." . makefile-mode)
         )
  )

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :magic ("\\`==\\+==" . markdown-mode)
  :init (setq markdown-command "multimarkdown")
  ;; :hook (markdown-mode . (lambda () (orgtbl-mode 1)))
  )

(use-package mu4e
  :config
  (setq mu4e-maildir       "~/me/footprint/mail" ;; top-level Maildir
        mu4e-sent-folder   "/sent"               ;; folder for sent messages
        mu4e-drafts-folder "/drafts"             ;; unfinished messages
        mu4e-trash-folder  "/trash"              ;; trashed messages
        mu4e-refile-folder "/archive"            ;; saved messages
        )

  ;; ;; (setq mu4e-get-mail-command "offlineimap"   ;; or fetchmail, or ...
  ;; ;;      mu4e-update-interval 300              ;; update every 5 minutes
  ;; ;;      )

  ;; ;; ;; tell message-mode how to send mail
  ;; ;; (setq message-send-mail-function 'smtpmail-send-it)
  ;; ;; ;; if our mail server lives at smtp.example.org; if you have a
  ;; ;; ;; local mail-server, simply use 'localhost' here.
  ;; ;; (setq smtpmail-smtp-server "smtp.example.org")
  ;; ;; ;; don't save messages to Sent Messages, Gmail/IMAP takes care of this
  ;; ;; (setq mu4e-sent-messages-behavior 'delete)
  )

;; ocaml
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
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
  :hook ((tuareg-mode caml-mode) . merlin-mode)
  :hook
  (tuareg-mode .
               (lambda ()
                 (setq merlin-use-auto-complete-mode 'easy
                       ;; indent-line-function 'ocp-indent-line
                       ;; indent-region-function 'ocp-indent-region
                       )
                 ))
  :bind (:map tuareg-mode-map
              ("C-S-<up>" . merlin-type-enclosing-go-up)
              ("C-S-<down>" . merlin-type-enclosing-go-down)
              )
  :mode (("\\.ml[iylp]?$" . tuareg-mode)
         ("\\.fs[ix]?$" . tuareg-mode)
         ("[i]?ocamlinit$" . tuareg-mode)
         )
  )

;; org-mode
(use-package org
  :defer t
  :pin org
  :bind (:map org-mode-map
              ("C-c a"    . org-agenda)
              ("S-<up>"   . org-move-line-up)
              ("S-<down>" . org-move-line-down)
              )

  :init
  ;; https://www.reddit.com/r/emacs/comments/5wj76n/orgagendarescheduletotoday/
  (defun org-agenda-reschedule-to-today (&optional arg)
    "Bulk reschedule selected tasks for today."
    (interactive "P")
    (org-agenda-schedule arg ".")
    )

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

  ;; TODO make :bind?
  ;; :bind (:map org-agenda-mode-map
  ;;        ("C-x ." . org-agenda-reschedule-to-today)
  ;;        )
  :config
  (add-hook
   'org-agenda-mode-hook
   '(lambda ()
      (local-set-key (kbd "C-x .") 'org-agenda-reschedule-to-today)
      ))

  ;; http://stackoverflow.com/questions/6997387/how-to-archive-all-the-done-tasks-using-a-single-command#6998051
  (defun org-archive-done-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (outline-previous-heading)))
     "/DONE" 'agenda)
    )
  (defun org-archive-cancelled-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (outline-previous-heading)))
     "/CANCELLED" 'agenda)
    )

  ;; use vertical splitting, http://orgmode.org/worg/org-hacks.html
  (defadvice org-prepare-agenda (after org-fix-split)
    (toggle-window-split))
  (ad-activate 'org-prepare-agenda)

  ;; customise my agenda options
  (setq org-agenda-custom-commands
        '(("O" "Office block agenda"
           ((agenda "" ((org-agenda-ndays 1))) ; display single day
            (todo "WAITING")
            )
           ((org-agenda-compact-blocks t)
            )
           )

          ("c" todo #("DONE|CANCELLED" 0 14 (face org-warning)) nil)
          ("w" todo #("WAITING" 0 7 (face org-warning)) nil)
          ("u" todo "" ((org-agenda-todo-ignore-scheduled t)))

          ("W" agenda "" ((org-agenda-ndays 21)))
          ("a" "Week agenda"
           ((agenda ""
                    ((org-agenda-ndays 7)
                     (org-agenda-start-on-weekday 1)
                     (org-agenda-remove-tags t)
                     (org-agenda-skip-deadline-if-done t)
                     (org-agenda-skip-scheduled-if-done t)
                     (org-agenda-skip-timestamp-if-done t)
                     (org-agenda-time-grid nil)
                     (org-agenda-repeating-timestamp-show-all t)
                     (org-deadline-warning-days 15)
                     (org-agenda-sorting-strategy
                      '(habit-up
                        time-up
                        priority-down
                        category-keep
                        todo-state-down
                        ))
                     ))
            )
           ((org-agenda-compact-blocks t)
            )
           )
          ("A" agenda ""
           ((org-agenda-skip-function
             (lambda nil
               (org-agenda-skip-entry-if
                (quote notregexp) "\\=.*\\[#A\\]")))
            (org-agenda-ndays 1)
            (org-agenda-overriding-header "Today's Priority #A tasks: "))
           )
          )

        org-agenda-files (append (directory-files-recursively "~/me/todo/todo.org$")
                                 (directory-files-recursively "~/Dropbox/people/family.org/" "\.org$")
                                 )
        org-agenda-include-diary t
        org-agenda-log-mode-items (quote (closed clock))
        org-agenda-ndays 7
        org-agenda-show-all-dates t
        org-agenda-sorting-strategy (quote (time-up todo-state-down category-keep priority-down alpha-down))
        org-agenda-start-on-weekday nil
        org-deadline-warning-days 14
        org-default-notes-file "~/me/todo/notes.org"
        org-fast-tag-selection-single-key (quote expert)
        org-remember-store-without-prompt t
        org-remember-templates (quote ((116 "* %? %u" "~/me/todo/todo.org" "Tasks")
                                       (110 "* %u %?" "~/me/todo/notes.org" "Notes"))
                                      )
        org-reverse-note-order t
        org-tags-match-list-sublevels t
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

;; on-screen
;; (on-screen-global-mode +1)

(use-package outline
  :diminish outline-minor-mode
  :hook ((emacs-lisp-mode LaTeX-mode) . outline-minor-mode)
  )

(use-package paren
  :config (setq show-paren-mode t
                show-paren-style (quote expression)
                )
  :hook (find-file . show-paren-mode)
  )

(use-package rainbow-mode
  :hook prog-mode
  )

(use-package saveplace ;; save cursor position in file after close
  :unless noninteractive
  :config (save-place-mode t)
  )

(use-package sh-script
  :mode (("bash_" . sh-mode)
         ("APKBUILD$" . sh-mode)
         )

  ;; :magic ("\\{{/* =% ssh %= */}}" . sh-mode)
  :config (setq sh-basic-offset 2
                sh-indentation 2
                )
  )

(use-package subword ;; subword -- obey CamelCase etc
  :config (setq global-subword-mode t)
  )

(use-package tex
  :ensure auctex
  :mode (("\\.tex$" . TeX-latex-mode)
         ("\\.latex$" . TeX-latex-mode)
         ("\\.bibtex$" . bibtex-mode)
         )
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         )
  :config
  (use-package latex)
  (setq bibtex-dialect 'biblatex
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

(use-package lisp-mode
  :mode "dune"
  )

(use-package web-mode
  :mode (("\\.html$" . web-mode)
         ("\\.tpl$" . web-mode)
         )
  :magic ("\\`<\\?xml" . web-mode)
  )

;; lilypond TODO

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/lilypond-elisp"))
;; (autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
;; (add-to-list 'auto-mode-alist '("\\.ly$" . LilyPond-mode))
;; (add-to-list 'auto-mode-alist '("\\.ily$" . LilyPond-mode))

(use-package visual-fill-column
  :hook (text-mode . visual-fill-column-mode)
  )

;; whitespace <https://github.com/jwiegley/dot-emacs/blob/master/init.el>
(use-package whitespace
  ;; :diminish (global-whitespace-mode
  ;;            whitespace-mode
  ;;            whitespace-newline-mode)
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
      (set-buffer-file-coding-system 'utf-8)
      (let ((require-final-newline t))
        (save-buffer))
      ))

  (defun maybe-turn-on-whitespace ()
    (when (not (locate-dominating-file default-directory ".noclean"))
      (progn
        ;; (if (memq major-mode '(markdown-mode))
        ;;     (setq whitespace-style '(face tabs lines-tail
        ;;                                   newline empty space-before-tab tab-mark)
        ;;           )
        (setq whitespace-style '(face trailing tabs lines-tail
                                      newline empty space-before-tab tab-mark)
              )
        ;; )
        (whitespace-mode t)
        )))

  :hook ((find-file . maybe-turn-on-whitespace)
         (prog-mode . whitespace-cleanup)
         )

  ;; :config
  ;; (remove-hook 'find-file-hook 'whitespace-buffer)
  ;; (remove-hook 'kill-buffer-hook 'whitespace-buffer)
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

(defun todo ()  (interactive) (find-file "~/me/todo/todo.org"))
(defun notes () (interactive) (find-file "~/me/todo/notes.org"))

;; theme switching
(defun light () "Light colour scheme."
       (interactive)
       (color-theme-sanityinc-solarized-light)
       )

(defun dark () "Dark colour scheme."
       (interactive)
       (color-theme-sanityinc-solarized-dark)
       )

;;
;; mode hooks
;;

(require 'filladapt)                    ; not a package :(
(add-hook 'text-mode-hook '(lambda () (filladapt-mode t)))

;;
;; keybindings
;;

;; (when (on-osx-p)
;;   (setq ns-alternate-modifier 'super
;;         ns-command-modifier 'meta
;;         ns-control-modifier 'control))

;; (when window-system
;;   (tooltip-mode -1)
;;   (tool-bar-mode -1)
;;   (menu-bar-mode -1)
;;   (scroll-bar-mode -1))

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
 ("C-x g"      . magit-status)
 ("C-x p"      . (lambda () (interactive) (other-window -1)))
 ("C-x z"      . my-suspend-frame)
 ("C-z"        . my-suspend-frame)
 ("M-%"        . replace-regexp)
 ("M-n"        . next-buffer)
 ("M-p"        . previous-buffer)
 ("M-q"        . unfill-toggle)
 ;; (define-key my-keys-minor-mode-map (kbd "C-x 3")      'my-split-window-right)

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
