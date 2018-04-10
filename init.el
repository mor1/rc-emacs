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

(defconst emacs-start-time (current-time))

;; evaluate locally if behind (eg) nottingham proxy
;; (setq url-proxy-services '(("http" . "proxy.nottingham.ac.uk:8080")))
;; (setq url-proxy-services '(("http" . "wwwcache.cs.nott.ac.uk:3128")))

;; (if init-file-debug
;;     (setq use-package-verbose t
;;           use-package-expand-minimally nil
;;           use-package-compute-statistics t
;;           debug-on-error t)
;;   (setq use-package-verbose nil
;;         use-package-expand-minimally t)
;;   )

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

;; theme switching
(defun light () "light colour scheme"
       (interactive)
       (color-theme-sanityinc-solarized-light))

(defun dark () "dark colour scheme"
       (interactive)
       (color-theme-sanityinc-solarized-dark))

;; fonts
(add-to-list 'default-frame-alist '(font . "Hack 10"))
;; (set-frame-font "-*-Hack-normal-normal-normal-*-16-*-*-*-m-0-fontset-auto2")
;; (set-frame-font "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-fontset-auto2")
;; (set-frame-font "-*-Hack-normal-normal-normal-*-12-*-*-*-m-0-fontset-auto2")
;; (set-frame-font "-*-Hack-normal-normal-normal-*-11-*-*-*-m-0-fontset-auto2")
;; (set-frame-font "-*-Hack-normal-normal-normal-*-10-*-*-*-m-0-fontset-auto2")

;;
;; package management
;; per http://cachestocaches.com/2015/8/getting-started-use-package/
;;

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant

(setq use-package-always-ensure t)
(setq use-package-verbose t)

;; ;; auto-update packages
;; (use-package auto-package-update
;;   :config
;;   (setq auto-package-update-delete-old-versions t)
;;   (setq auto-package-update-hide-results t)
;;   (auto-package-update-maybe)
;;   )

;;
;; packages
;;

;; set exec path
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; web-mode
(use-package web-mode
  :mode (("\\.html$" . web-mode)
         ("\\.tpl$" . web-mode)
         )
  :magic ("\\`<\\?xml" . web-mode)
  )

;; markdown-mode
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :magic ("\\`==\\+==" . markdown-mode)
  :init
  (setq markdown-command "multimarkdown")
  :hook
  (markdown-mode . (lambda () (orgtbl-mode 1)))
  )

;; makefile-mode
(use-package make-mode
  :mode (("sources$" . makefile-mode)
         ("Makefile." . makefile-mode)
         )
  )

;; eldoc
(use-package eldoc
  :diminish
  :hook ((c-mode-common emacs-lisp-mode lisp-interaction-mode) . eldoc-mode)
  )

;; mu4e
(require 'mu4e)
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
;; )

;; csv/tsv
(use-package csv-mode
  :mode
  ("\\.tsv$")
  :config
  (setq indent-tabs-mode 't)
  )

;; sh/bash
(use-package sh-script
  :mode
  ("bash_" . sh-mode)
  )

;; css
(use-package css-mode
  :mode
  ("\\.less$")
  )

;; save cursor position in file after close
(use-package saveplace
  :unless noninteractive
  :config
  (save-place-mode 1)
  )

;; ocaml TODO
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
;; ;; ;; ocaml
;; (let ((opam-share (ignore-errors
;;                     (car (process-lines "opam" "config" "var" "share")))))
;;   (when (and opam-share (file-directory-p opam-share))
;;     ;; Register Merlin
;;     (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
;;     (autoload 'merlin-mode "merlin" nil t nil)
;;     ;; Automatically start it in OCaml buffers
;;     (add-hook 'tuareg-mode-hook 'merlin-mode t)
;;     (add-hook 'caml-mode-hook 'merlin-mode t)
;;     ;; Use opam switch to lookup ocamlmerlin binary
;;     (setq merlin-command 'opam)
;;     ))

;; (add-hook 'tuareg-mode-hook
;;           '(lambda ()
;;              ;; (setq indent-line-function 'ocp-indent-line)
;;              ;; (setq indent-region-function 'ocp-indent-region)
;;              (setq merlin-use-auto-complete-mode 'easy)
;;              (local-set-key (kbd "C-S-<up>") 'merlin-type-enclosing-go-up)
;;              (local-set-key (kbd "C-S-<down>") 'merlin-type-enclosing-go-down)
;;              ))
;; ;; (push'("\\.ml[iylp]?" . tuareg-mode) auto-mode-alist)
;; ;; (push '("\\.fs[ix]?" . tuareg-mode) auto-mode-alist)
;; ;; (push '("[i]?ocamlinit$" . tuareg-mode) auto-mode-alist)


;; ;; lilypond

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/lilypond-elisp"))
;; (autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
;; (add-to-list 'auto-mode-alist '("\\.ly$" . LilyPond-mode))
;; (add-to-list 'auto-mode-alist '("\\.ily$" . LilyPond-mode))

;; fill column indicator
(use-package fill-column-indicator
  :config
  (add-hook 'prog-mode-hook 'fci-mode)
  )

;; visual fill column
(use-package visual-fill-column
  :hook (text-mode . visual-fill-column-mode)
  )

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode)
  )

;; outline
(use-package outline
  :diminish outline-minor-mode
  :hook ((emacs-lisp-mode LaTeX-mode) . outline-minor-mode)
  )

;; latex TODO
(use-package tex
  :ensure auctex
  :mode (("\\.tex$" . TeX-latex-mode)
         ("\\.latex$" . TeX-latex-mode)
         ("\\.bibtex$" . bibtex-mode)
         )
  :config
  (setq bibtex-dialect 'biblatex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq reftex-plug-into-AUCTeX t)

  ;;     ;; (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  ;;     ;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  ;;     ;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  ;;     ;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  ;; ;; (add-hook 'occur-mode-hook 'fm-start)
  ;; ;; (add-hook 'compilation-mode-hook 'fm-start)

  ;; (add-hook 'LaTeX-mode-hook
  ;;           '(lambda ()
  ;;              (auto-fill-mode 0)
  ;;              (local-set-key (kbd "M-q") 'unfill-and-check)
  ;;              (local-set-key (kbd "{") 'tex-insert-braces)
  ;;              (local-set-key
  ;;               (kbd "M-[") '(lambda () (interactive) (insert "{")))
  ;;              (local-set-key
  ;;               (kbd "M-]") '(lambda () (interactive) (insert "}")))
  ;;              (local-set-key
  ;;               (kbd "C-c m")
  ;;               '(lambda () (interactive "*") (tex-enclose-word "\\emph{" "}")))
  ;;              (local-set-key
  ;;               (kbd "C-c C-m")
  ;;               '(lambda () (interactive "*") (tex-enclose-word "\\emph{" "}")))
  ;;              (local-set-key
  ;;               (kbd "C-c b")
  ;;               '(lambda () (interactive "*") (tex-enclose-word "{\\bf " "}")))
  ;;              (local-set-key (kbd "%") 'match-paren)
  ;;              ))

  ;; ;; modified from swiftex.el
  ;; (defun tex-enclose-word (before after)
  ;;   (interactive "*Mbefore: \nMafter: ")
  ;;   (let* ((oldpoint (point))
  ;;          (start oldpoint)
  ;;          (end oldpoint))

  ;;     ;; get the start and end of the current word
  ;;     (skip-syntax-backward "w")
  ;;     (setq start (point))
  ;;     (goto-char oldpoint)
  ;;     (skip-syntax-forward "w")
  ;;     (setq end (point))
  ;;     (if (and (eq start oldpoint)
  ;;              (eq end oldpoint))
  ;;         ;; insert the command as nothing to enclose
  ;;         (progn (insert before) (insert after) (backward-char))

  ;;       ;; enclose the word with the command
  ;;       (progn
  ;;         (insert after)
  ;;         (goto-char start)
  ;;         (insert before)
  ;;         (goto-char (+ oldpoint (length before)))
  ;;         )
  ;;       )))
  )

;; ispell
(use-package ispell
  :config
  (setq ispell-dictionary "british")
  )

;; ;; prb ispell functions
;; (defun ispell-check-paragraph ()
;;   "Spell check each word in a paragraph"
;;   (interactive "*")
;;   (let ((ispell-check-only nil)
;;         (ispell-quietly t)
;;         )
;;     (save-excursion
;;       (forward-paragraph) (setq end (point))
;;       (forward-paragraph -1) (setq start (point))
;;       (ispell-region start end))
;;     ))

;; coffee
(use-package coffee-mode
  :config
  (coffee-cos-mode t)
  (setq coffee-tab-width 2)
  (setq coffee-command "/usr/local/bin/coffee")
  )

;; go
(use-package go-mode
  :config (setq gofmt-command "goimports")
  :hook ((before-save-hook . gofmt-before-save))
  )

;; json
(use-package json-mode
  :mode "\\.json$"
  )

(use-package json-reformat
  :after json-mode
  )

;; org-mode
(use-package org
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
                 (list (list (list 1 3 y)
                             "New Year's Day Bank Holiday")))
                ((= d 0)
                 (list (list (list 1 2 y)
                             "New Year's Day Bank Holiday"))))))))

  (defun holiday-christmas-bank-holidays ()
    (let ((m displayed-month)
          (y displayed-year))
      (calendar-increment-month m y -1)
      (when (>= m 10)
        (let ((d (calendar-day-of-week (list 12 25 y))))
          (cond ((= d 5)
                 (list (list (list 12 28 y)
                             "Boxing Day Bank Holiday")))
                ((= d 6)
                 (list (list (list 12 27 y)
                             "Boxing Day Bank Holiday")
                       (list (list 12 28 y)
                             "Christmas Day Bank Holiday")))
                ((= d 0)
                 (list (list (list 12 27 y)
                             "Christmas Day Bank Holiday")))
                )))))

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
          ))
  )

(use-package calendar
  :config
  (defun insert-current-date (&optional omit-day-of-week-p)
    (interactive "P*")
    (insert
     (calendar-date-string (calendar-current-date) t omit-day-of-week-p)
     ))
  )

;; TODO: sort out fill modes


;; ;; ;; tweak auto-fill
;; ;; (setq paragraph-start "\f\\|[ \t]*$\\| *[-*+] +.+$"
;; ;;       paragraph-separate "$")

;; magit mode
(use-package magit
  :config
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
  :hook (magit-status-mode-hook . (lambda () (visual-line-mode 0)))
  )

;; whitespace <https://github.com/jwiegley/dot-emacs/blob/master/init.el>
(use-package whitespace
  :diminish (global-whitespace-mode
             whitespace-mode
             whitespace-newline-mode)
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
        (save-buffer))))

  (defun maybe-turn-on-whitespace ()
    (when
        (not (or (memq major-mode '(markdown-mode))
                 (locate-dominating-file default-directory ".noclean")))
      (setq whitespace-style '(face trailing tabs lines-tail
                                    newline empty space-before-tab tab-mark)
            )
      (whitespace-mode t)
      ;; (whitespace-cleanup)
      ))

  :init
  (add-hook 'find-file-hook 'maybe-turn-on-whitespace t)
  (add-hook 'prog-mode-hook 'whitespace-cleanup)

  :config
  (remove-hook 'find-file-hook 'whitespace-buffer)
  (remove-hook 'kill-buffer-hook 'whitespace-buffer)
  )

;;
;; functions
;;

;; http://whattheemacsd.com/
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1))
  )
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun line-to-top-of-window ()
  "Move line point is on to top of window"
  (interactive)
  (recenter 0)
  )

(defun line-to-bottom-of-window ()
  "Move line point is on to bottom of window"
  (interactive)
  (recenter -1)
  )

(defun warp-to-top-of-window ()
  "Move the point to top of window"
  (interactive)
  (move-to-window-line 0)
  )

(defun warp-to-bottom-of-window ()
  "Move the point to bottom of window"
  (interactive)
  (move-to-window-line -1)
  )

(defun reread-dot-emacs ()
  "Re-read initialisation"
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )

(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1))))
  )

(defun my-kill-emacs ()
  "Confirm before save-buffers-kill-emacs"
  (interactive)
  (if (y-or-n-p "Really kill emacs? ")
      (save-buffers-kill-emacs)
    (message "Aborted"))
  )

(defun my-suspend-frame ()
  "Confirm before suspend emacs"
  (interactive)
  (if (y-or-n-p "Really minimise? ")
      (suspend-frame)
    (message "Aborted"))
  )

(defun todo ()
  (interactive)
  (find-file "~/me/todo/todo.org"))

(defun notes ()
  (interactive)
  (find-file "~/me/todo/notes.org"))

;;
;; mode hooks
;;

(require 'filladapt)                    ; not a package :(
(add-hook
 'text-mode-hook
 '(lambda ()
    (filladapt-mode t)
    )
 )

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
 ("C-c C-q"    . indent-region)
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
               ,load-file-name elapsed))) t)
