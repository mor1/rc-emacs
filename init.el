;; Copyright (C) 2000--2015 Richard Mortier <mort@cantab.net> except where
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

;;
;; config
;;

;; time emacs startup; updated to new (current-time)
;;  http://a-nickels-worth.blogspot.co.uk/2007/11/effective-emacs.html
(require 'cl)
(defvar *emacs-load-start* (current-time))

;; split out customisations
(setq custom-file "~/.emacs.d/init-custom.el")

;; tidy-up display on startup <http://whattheemacsd.com/>
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-message t)

;; server
(load "server")
(setq server-socket-dir (format "/tmp/emacs-%s" (user-login-name)))
(unless (server-running-p) (server-start))

;; input method
(setq default-input-method "TeX")

;; <http://stackoverflow.com/questions/8606954/
;;    path-and-exec-path-set-but-emacs-does-not-find-executable>
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to
  match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not
started from a shell."
  (interactive)
  (let ((path-from-shell
         (replace-regexp-in-string
          "[ \t\n]*$" ""
          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))
         ))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator)))
  )
(set-exec-path-from-shell-PATH)

;; package management
(eval-after-load "package"
  '(progn
     (add-to-list 'package-archives
                  '("marmalade" . "http://marmalade-repo.org/packages/"))
     (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
     (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
     (add-to-list 'package-archives
                  '("melpa" . "http://melpa.milkbox.net/packages/") t)

     (package-initialize)
     ))

;; evaluate locally if behind nottingham proxy
;; (setq url-proxy-services '(("http" . "proxy.nottingham.ac.uk:8080")))
;; (setq url-proxy-services '(("http" . "wwwcache.cs.nott.ac.uk:3128")))

;; colours
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'eshell-preoutput-filter-functions 'ansi-color-filter-apply)
(add-hook 'comint-output-filter-functions 'ansi-color-process-output)

;; need to initialise packages as themes are loaded *after* `init.el` processed
(setq package-enable-at-startup nil)
(package-initialize)

(defun light () "light colour scheme"
       (interactive)
       (color-theme-sanityinc-solarized-light)
       )
(defun dark () "dark colour scheme"
       (interactive)
       (color-theme-sanityinc-solarized-dark)
       )

;; fonts
;; for display purposes
;; (set-frame-font "-*-Hack-normal-normal-normal-*-16-*-*-*-m-0-fontset-auto2")
;; (set-frame-font "-*-Hack-normal-normal-normal-*-12-*-*-*-m-0-fontset-auto2")
(set-frame-font "-*-Hack-normal-normal-normal-*-10-*-*-*-m-0-fontset-auto2")

;; frame size
(if window-system
    (set-frame-size (selected-frame) 90 50)
  (set-frame-position (selected-frame) 0 0)
  )

;; ispell
(setq-default ispell-program-name "/usr/local/bin/aspell")
(setq ispell-dictionary "british")

;; default save encoding- ut8
(set-language-environment "utf-8")
(set-coding-priority (list 'coding-category-utf-8))
(prefer-coding-system 'utf-8)

(defun screen-width nil -1) ;; squash some spurious error when using pgup, etc

;; remember cursor position in file after close
(setq-default save-place t)
(require 'saveplace)

;; remember point position when scrolling
(setq scroll-preserve-screen-position t)

;; tweak auto-fill
(setq paragraph-start "\f\\|[ \t]*$\\| *[-*+] +.+$"
      paragraph-separate "$")

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
    (linum-mode -1)))
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun insert-euro ()
  "Insert euro character"
  (interactive)
  (self-insert-command "€")
  )

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

(defun dos2unix ()
  "Turn DOS file to Unix"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-string "\015" "")
    ))

(defun unix2dos ()
  "Turn Unix file to DOS"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-string "\012" "\015\012")
    ))

(defun mime2unix ()
  "Get rid of MIME =RET junk"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-string "=\n" "")
    (replace-string "=20" "")
    ))

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

;; visual wrap mode breaks split-window-right
(defun my-split-window-right ()
  "split window while toggling visual wrap"
  (interactive)
  (let (saved-visual-wrap-column visual-wrap-column)
    (set-visual-wrap-column 0)
    (split-window-right)
    ;; (other-window 1)
    (visual-line-mode t)
    (set-visual-wrap-column saved-visual-wrap-column)
    (redraw-display)
    )
  )

;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
;;; Takes a multi-line paragraph and makes it into a single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)
    )
  )

;;; Code Cleanup for Emacs V1.0
;;; http://blog.modp.com/2008/11/handy-emacs-functions-for-code-cleanup.html
;;; PUBLIC DOMAIN

;; zap tabs
(defun buffer-untabify ()
  "Untabify an entire buffer"
  (interactive)
  (untabify (point-min) (point-max))
  )

;; re-indent buffer
(defun buffer-indent ()
  "Reindent an entire buffer"
  (interactive)
  (indent-region (point-min) (point-max) nil)
  )

;; prb ispell functions
(defun ispell-check-paragraph ()
  "Spell check each word in a paragraph"
  (interactive "*")
  (let ((ispell-check-only nil)
        (ispell-quietly t)
        )
    (save-excursion
      (forward-paragraph) (setq end (point))
      (forward-paragraph -1) (setq start (point))
      (ispell-region start end))
    ))

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

(defun todo ()
  (interactive)
  (find-file "~/me/todo/todo.org")
  )
(defun notes ()
  (interactive)
  (find-file "~/me/todo/notes.org")
  )

(require 'calendar)
(defun insdate-insert-current-date (&optional omit-day-of-week-p)
  "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
  (interactive "P*")
  (insert (calendar-date-string
           (calendar-current-date) nil omit-day-of-week-p))
  )

;; from <http://www.emacswiki.org/emacs/VisualLineMode>
(defvar visual-wrap-column nil)
(defun update-visual-wrap-column ()
  (if (not visual-wrap-column)
      (set-window-margins nil nil)
    (let* ((current-margins (window-margins))
           (right-margin (or (cdr current-margins) 0))
           (current-width (window-width))
           (current-available (+ current-width right-margin)))
      (if (<= current-available visual-wrap-column)
          (set-window-margins nil (car current-margins))
        (set-window-margins nil (car current-margins)
                            (- current-available visual-wrap-column))))))

(defun set-visual-wrap-column (new-wrap-column &optional buffer)
  "Force visual line wrap at NEW-WRAP-COLUMN in BUFFER (defaults
    to current buffer) by setting the right-hand margin on every
    window that displays BUFFER.  A value of NIL or 0 for
    NEW-WRAP-COLUMN disables this behavior."
  (interactive
   (list (read-number "New visual wrap column, 0 to disable: "
                      (or visual-wrap-column 0))))
  (if (and (numberp new-wrap-column)
           (zerop new-wrap-column))
      (setq new-wrap-column nil))
  (with-current-buffer (or buffer (current-buffer))
    (visual-line-mode t)
    (set (make-local-variable 'visual-wrap-column) new-wrap-column)
    (add-hook 'window-configuration-change-hook 'update-visual-wrap-column nil t)
    (let ((windows (get-buffer-window-list)))
      (while windows
        (when (window-live-p (car windows))
          (with-selected-window (car windows)
            (update-visual-wrap-column)))
        (setq windows (cdr windows))))))

(defun unfill-and-check ()
  (interactive)
  (unfill-paragraph)
  (ispell-check-paragraph)
  )

(defun fill-and-check ()
  (interactive)
  (fill-paragraph)
  (ispell-check-paragraph)
  )

;; http://ergoemacs.org/emacs/emacs_make_modern.html
(defun xah-toggle-margin-right ()
  "Toggle the right margin between `fill-column' or window width.
This command is convenient when reading novel, documentation."
  (interactive)
  (if (eq (cdr (window-margins)) nil)
      (set-window-margins nil 0 (- (window-body-width) (+ fill-column 2)))
    (set-window-margins nil 0 0)
    ))

;; http://ergoemacs.org/emacs/emacs_toggle_line_spacing.html
(defun xah-toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height."
  (interactive)
  (if (eq line-spacing nil)
      (setq line-spacing 0.5) ; add 0.5 height between lines
    (setq line-spacing nil)   ; no extra height between lines
    )
  (redraw-frame (selected-frame)))


;; http://emacswiki.org/emacs/DuplicateLines
(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((lines) (end (copy-marker end)))
      (goto-char start)
      (while (and (< (point) (marker-position end))
                  (not (eobp)))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position) (line-end-position))))
          (if (member line lines)
              (delete-region (point) (progn (forward-line 1) (point)))
            (push line lines)
            (forward-line 1)))))))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

;; notmuch email
(autoload 'notmuch "notmuch" "notmuch mail" t)

;; magit mode
(autoload 'magit-status "magit" nil t)
;; (add-hook 'magit-status-mode-hook 'magit-filenotify-mode)

;; change magit diff colors
(eval-after-load 'magit
  '(progn
     (when (not window-system)
       (set-face-background 'magit-item-highlight "black")
       )
     ))

;; magit whitespace in diffs <http://whattheemacsd.com/>
(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

;; (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;;
;; mode hooks
;;

(add-hook 'find-file-hook
          '(lambda ()
             (message "running find-file-hook")
             (whitespace-mode t)
             (hl-line-mode t)
             (force-my-keys-minor-mode)
             (auto-fill-mode t)
             (git-ps1-mode t)
             ))

(add-hook 'text-mode-hook
          '(lambda ()
             (message "running text-mode-hook")
             (flyspell-mode t)
             (turn-on-visual-line-mode)
             (set-visual-wrap-column (+ fill-column 2))
             (local-set-key (kbd "M-q") 'fill-and-check)
             (local-set-key (kbd "S-<tab>")
                            'flyspell-auto-correct-previous-word)
             ))

;; prog-mode is not yet universally supported, so apply manually where missing
(defun prog-mode-hook-f ()
  (interactive)
  (message "running prog-mode-hook")

  ;; (set-visual-wrap-column 0)
  (fci-mode t)
  (flyspell-prog-mode)
  (whitespace-cleanup)
  ;; (setq indent-region-function 'nil) ;; clean up ocp-indent bug
  (local-set-key (kbd "M-q") 'fill-paragraph)
  (local-set-key (kbd "%") 'match-paren)
  (local-unset-key (kbd "S-<tab>"))
  )
(add-hook 'prog-mode-hook 'prog-mode-hook-f)
(mapc (lambda (mode-hook) (add-hook mode-hook 'prog-mode-hook-f))
      '(tuareg-mode-hook
        nxml-mode-hook
        emacs-lisp-mode-hook
        ))

(add-hook 'org-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c a") 'org-agenda)
             (local-set-key (kbd "S-<up>") 'org-move-line-up)
             (local-set-key (kbd "S-<down>") 'org-move-line-down)
             (local-set-key (kbd "S-C-<tab>") 'org-shifttab)
             (local-set-key (kbd "C-x C-d") `insdate-insert-current-date)
             (local-unset-key (kbd "M-<return>"))
             ))

(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (hl-line-mode 1)
             (local-set-key (kbd "C-x .") 'org-agenda-reschedule-to-today)
             ))

(add-hook 'latex-mode-hook
          '(lambda ()
             (auto-fill-mode 0)
             (local-set-key (kbd "M-q") 'unfill-and-check)
             (local-set-key (kbd "{") 'tex-insert-braces)
             (local-set-key
              (kbd "M-[") '(lambda () (interactive) (insert "{")))
             (local-set-key
              (kbd "M-]") '(lambda () (interactive) (insert "}")))
             (local-set-key
              (kbd "C-c m")
              '(lambda () (interactive "*") (tex-enclose-word "\\emph{" "}")))
             (local-set-key
              (kbd "C-c C-m")
              '(lambda () (interactive "*") (tex-enclose-word "\\emph{" "}")))
             (local-set-key
              (kbd "C-c b")
              '(lambda () (interactive "*") (tex-enclose-word "{\\bf " "}")))
             (local-set-key (kbd "%") 'match-paren)
             ))
(push '("\\.tex$" . latex-mode) auto-mode-alist)
(push '("\\.latex$" . latex-mode) auto-mode-alist)

(add-hook 'java-mode-hook
          '(lambda ()
             (setq c-basic-offset 4)
             (setq c-set-style "java")
             ))

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)
             ))

(add-hook 'lisp-interaction-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)
             ))

(add-hook 'coffee-mode-hook
          '(lambda ()
             (coffee-cos-mode t)
             (setq coffee-tab-width 2)
             (setq coffee-command "/usr/local/bin/coffee")
             ))

;; php-mode
(push '("\\.php$" . php-mode) auto-mode-alist)

;; bibtex-mode
(push '("\\.bibtex$" . bibtex-mode) auto-mode-alist)

;; web-mode
(push '("\\`<\\?xml" . web-mode) magic-mode-alist)
(push '("\\.html$" . web-mode) auto-mode-alist)
(push '("\\.tpl$" . web-mode) auto-mode-alist) ;; bottle templates

;; markdown-mode
(add-hook 'markdown-mode-hook
          '(lambda ()
             (orgtbl-mode 1)
             (auto-fill-mode 0)
             ;; (local-set-key (kbd "M-q") 'unfill-and-check)
             ))
(push '("\\.md$" . markdown-mode) auto-mode-alist)
(push '("\\.markdown$" . markdown-mode) auto-mode-alist)
(push '("\\`==\\+==" . markdown-mode) magic-mode-alist)

;; makefile-mode
(defadvice whitespace-cleanup (around whitespace-cleanup-indent-tab activate)
  "Fix whitespace-cleanup indent-tabs-mode bug"
  (let ((whitespace-indent-tabs-mode indent-tabs-mode)
        (whitespace-tab-width tab-width))
    ad-do-it))

(push '("sources$" . makefile-mode) auto-mode-alist)
(push '("Makefile." . makefile-mode) auto-mode-alist)

(push '("bash_" . sh-mode) auto-mode-alist)

;; css-mode
(push '("\\.less$" . css-mode) auto-mode-alist)

;; ocaml
(setq explicit-bash-args '("--login" "-i"))

(setq opam-share
      (substring
       (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

(require 'ocp-index)
(require 'ocp-indent)
(require 'merlin)

(setq merlin-use-auto-complete-mode 'easy)
(setq merlin-command 'opam)

(add-hook 'caml-mode-hook 'merlin-mode t)
(add-hook 'tuareg-mode-hook
          '(lambda ()
             (merlin-mode)
             ;; (setq indent-line-function 'ocp-indent-line)
             ;; (setq indent-region-function 'ocp-indent-region)
             (setq merlin-use-auto-complete-mode 'easy)
             ;; (setq tuareg-lazy-= t) ; indent `=' like a standard keyword
             ;; (setq tuareg-lazy-paren t) ; indent [({ like standard keywords
             ;; (setq tuareg-in-indent 0) ; no indentation after `in' keywords
             (local-set-key (kbd "C-S-<up>") 'merlin-type-enclosing-go-up)
             (local-set-key (kbd "C-S-<down>") 'merlin-type-enclosing-go-down)
             ))
(push'("\\.ml[iylp]?" . tuareg-mode) auto-mode-alist)
(push '("\\.fs[ix]?" . tuareg-mode) auto-mode-alist)
(push '("[i]?ocamlinit$" . tuareg-mode) auto-mode-alist)

;; org-mode: Holidays -- from <http://www.gnomon.org.uk/diary.html>

;;UK public holidays, and other UK notable dates.
(setq general-holidays
      '((holiday-fixed 1 1 "New Year's Day")
        (holiday-new-year-bank-holiday)
        (holiday-fixed 2 14 "Valentine's Day")
        (holiday-fixed 3 17 "St. Patrick's Day")
        (holiday-fixed 4 1 "April Fools' Day")
        (holiday-easter-etc -47 "Shrove Tuesday")
        (holiday-easter-etc -21 "Mother's Day")
        (holiday-easter-etc -2 "Good Friday")
        (holiday-easter-etc 0 "Easter Sunday")
        (holiday-easter-etc 1 "Easter Monday")
        (holiday-float 5 1 1 "Early May Bank Holiday")
        (holiday-float 5 1 -1 "Spring Bank Holiday")
        (holiday-float 6 0 3 "Father's Day")
        (holiday-float 8 1 -1 "Summer Bank Holiday")
        (holiday-fixed 10 31 "Halloween")
        (holiday-fixed 12 24 "Christmas Eve")
        (holiday-fixed 12 25 "Christmas Day")
        (holiday-fixed 12 26 "Boxing Day")
        (holiday-christmas-bank-holidays)
        (holiday-fixed 12 31 "New Year's Eve")
        ))

;; ;;Major US holidays
;; (setq other-holidays
;;       '((holiday-float 1 1 3 "Martin Luther King Day")
;;         (holiday-float 2 1 3 "President's Day")
;;         (holiday-float 5 1 -1 "Memorial Day")
;;         (holiday-fixed 7 4 "Independence Day")
;;         (holiday-float 9 1 1 "Labor Day")
;;         (holiday-float 10 1 2 "Columbus Day")
;;         (holiday-fixed 11 11 "Veteran's Day")
;;         (holiday-float 11 4 4 "Thanksgiving")))

;; N.B. It is assumed that 1 January is defined with holiday-fixed - this
;; function only returns any extra bank holiday that is allocated (if any) to
;; compensate for New Year's Day falling on a weekend.

;; Where 1 January falls on a weekend, the following Monday is a bank holiday.
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

;; N.B. It is assumed that 25th and 26th are defined with holiday-fixed - this
;; function only returns any extra bank holiday(s) that are allocated (if any)
;; to compensate for Christmas Day and/or Boxing Day falling on a weekend.

;; Christmas day is always 25 December; beyond that there is no entirely
;; consistent practice. We proceed as follows:

;; Traditionally, Boxing day was the first day after Christmas, not including
;; Sundays (i.e. if Christmas fell on a Saturday, Boxing Day was Monday 27th)
;; however we follow modern practice here and always regard Boxing Day as 26
;; December (which, as noted above, is never returned by this function).

;; Generally the extra bank holiday is allocated on the first available day that
;; would otherwise have been a working day. However in the case where we need to
;; allocate two additional bank holidays - i.e. where Christmas Day falls on the
;; Saturday, there is some confusion as to how to proceed. We allocate the
;; Boxing Day Bank Holiday to the Monday, since this is the historic date of
;; Boxing Day in this case, and allocate the Christmas Day Bank Holiday to the
;; following day.

;; This is consistent with the way that the 'substitute days' were allocated in
;; the list of bank holidays on the Department of Trade and Industry in the
;; recent past, although they don't use the any specific names for these
;; holidays.

;; The latest list on the direct.gov.uk web site is not consistent with this
;; practice, however, allocating the substitute days for Christmas Day and
;; Boxing Day in the other order in 2010. However this list also manages to
;; allocate them in order in 2011 (where Christmas Day falls on a Sunday),
;; therefore placing the substitute holiday for Christmas Day _on_ Boxing Day,
;; and then the substitute holiday for Boxing Day on the following day. I'm not
;; at all sure this isn't a mistake.

;; In any case, this is largely academic as there is no dispute over
;; which days are public holidays, only what to call them - so unless
;; you care deeply just ignore the issue and use the function as
;; supplied.
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

;;Comment out the Christian holidays that also have secular
;;significance in the UK (Shrove Tuesday, Good Friday, Easter Sunday,
;;Christmas) as EMACS doesn't remove duplicates holidays.  These
;;holidays are included in the UK redefinition of general-holidays
;;(where Chistmas is listed as Christmas Day).
(setq christian-holidays
      '((if all-christian-calendar-holidays
            (holiday-fixed 1 6 "Epiphany"))
        ;;   (holiday-easter-etc 0 "Easter Sunday")
        ;;   (holiday-easter-etc -2 "Good Friday")
        (holiday-easter-etc -46 "Ash Wednesday")
        (if all-christian-calendar-holidays
            (holiday-easter-etc -63 "Septuagesima Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -56 "Sexagesima Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -49 "Shrove Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -48 "Shrove Monday"))
        ;;   (if all-christian-calendar-holidays
        ;;       (holiday-easter-etc -47 "Shrove Tuesday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -14 "Passion Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -7 "Palm Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc -3 "Maundy Thursday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 35 "Rogation Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 39 "Ascension Day"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 49 "Pentecost (Whitsunday)"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 50 "Whitmonday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 56 "Trinity Sunday"))
        (if all-christian-calendar-holidays
            (holiday-easter-etc 60 "Corpus Christi"))
        (if all-christian-calendar-holidays
            (holiday-greek-orthodox-easter))
        (if all-christian-calendar-holidays
            (holiday-fixed 8 15 "Assumption"))
        (if all-christian-calendar-holidays
            (holiday-advent 0 "Advent"))
                                        ;   (holiday-fixed 12 25 "Christmas")
        (if all-christian-calendar-holidays
            (holiday-julian 12 25 "Eastern Orthodox Christmas"))))

(setq org-agenda-custom-commands
      '(
        ;; ("O" "Office block agenda"
        ;;  (
        ;;   ;; limits the agenda display to a single day
        ;;   (agenda "" ((org-agenda-ndays 1)))

        ;;   (tags-todo "+PRIORITY=\"A\"")
        ;;   (tags-todo "computer|office|phone")
        ;;   (tags "project+CATEGORY=\"elephants\"")
        ;;   (tags "review" ((org-agenda-files '("~/org/circuspeanuts.org"))))
        ;;   ;; limits the tag search to the file circuspeanuts.org
        ;;   (todo "WAITING"))

        ;;  ;; options set here apply to the entire block
        ;;  ((org-agenda-compact-blocks t))
        ;;  )

        ;; ("c" todo #("DONE|CANCELLED" 0 14 (face org-warning)) nil)

        ;; ("w" todo #("WAITING" 0 7 (face org-warning)) nil)

        ("a" ""
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

        ;; ("W" agenda "" ((org-agenda-ndays 21)))

        ("A" agenda ""
         ((org-agenda-skip-function
           (lambda nil
             (org-agenda-skip-entry-if
              (quote notregexp) "\\=.*\\[#A\\]")))
          (org-agenda-ndays 1)
          (org-agenda-overriding-header "Today's Priority #A tasks: "))
         )

        ("u" "Unscheduled" todo ""
         ((org-agenda-todo-ignore-scheduled t)))


        ;; ("u" alltodo ""
        ;;  ((org-agenda-skip-function
        ;;    (lambda nil
        ;;      (org-agenda-skip-entry-if
        ;;       (quote scheduled) (quote deadline)
        ;;       (quote regexp) "<[^>]+>")))
        ;;   (org-agenda-overriding-header "Unscheduled TODO entries: ")))
        ))

;; http://orgmode.org/worg/org-hacks.html
(defun org-agenda-reschedule-to-today ()
  (interactive)
  (flet ((org-read-date (&rest rest) (current-time)))
    (call-interactively 'org-agenda-schedule)
    ))

;; Patch org-mode to use vertical splitting, http://orgmode.org/worg/org-hacks.html
;; (defadvice org-prepare-agenda (after org-fix-split)
;;   (toggle-window-split))
;; (ad-activate 'org-prepare-agenda)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make my key-bindings win, except in minibuffer
;; <http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs>

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map (kbd "C-x C-c") 'my-kill-emacs)

(define-key my-keys-minor-mode-map (kbd "C-x z")   'my-suspend-frame)
(define-key my-keys-minor-mode-map (kbd "C-x C-z") 'my-suspend-frame)
(define-key my-keys-minor-mode-map (kbd "C-z")     'nil)

(define-key my-keys-minor-mode-map (kbd "C-x p")
  '(lambda () (interactive) (other-window -1)))
(define-key my-keys-minor-mode-map (kbd "C-c C-g")    'goto-line)
(define-key my-keys-minor-mode-map (kbd "C-c ;")      'comment-region)
(define-key my-keys-minor-mode-map (kbd "C-c C-q")    'indent-region)
(define-key my-keys-minor-mode-map (kbd "M-C-q")      'unfill-paragraph)
(define-key my-keys-minor-mode-map (kbd "M-%")        'replace-regexp)
(define-key my-keys-minor-mode-map (kbd "C-<tab>")    'dabbrev-expand)
(define-key my-keys-minor-mode-map (kbd "C-<return>") 'split-line)
(define-key my-keys-minor-mode-map (kbd "M-n")        'next-buffer)
(define-key my-keys-minor-mode-map (kbd "M-p")        'previous-buffer)
(define-key my-keys-minor-mode-map (kbd "C-x g")      'magit-status)
(define-key my-keys-minor-mode-map (kbd "C-x M-g")    'magit-dispatch-popup)
(define-key my-keys-minor-mode-map (kbd "C-c C-SPC")  'whitespace-cleanup)
(define-key my-keys-minor-mode-map (kbd "C-x 3")      'my-split-window-right)

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

;;
;; for poxy macbook keyboard with only the arrow keys
(define-key my-keys-minor-mode-map (kbd "C-<up>")     'backward-paragraph)
(define-key my-keys-minor-mode-map (kbd "C-<down>")   'forward-paragraph)
(define-key my-keys-minor-mode-map (kbd "M-<up>")     'warp-to-top-of-window)
(define-key my-keys-minor-mode-map (kbd "M-<down>")   'warp-to-bottom-of-window)
(define-key my-keys-minor-mode-map (kbd "C-M-<down>") 'line-to-top-of-window)
(define-key my-keys-minor-mode-map (kbd "C-M-<up>")   'line-to-bottom-of-window)

;;
;; for a sensible pc keyboard with pgup|pgdn|home|end
;;
(define-key my-keys-minor-mode-map (kbd "C-<prior>") 'warp-to-top-of-window)
(define-key my-keys-minor-mode-map (kbd "C-<next>")  'warp-to-bottom-of-window)
(define-key my-keys-minor-mode-map (kbd "C-<home>")  'line-to-top-of-window)
(define-key my-keys-minor-mode-map (kbd "C-<end>")   'line-to-bottom-of-window)
(define-key my-keys-minor-mode-map (kbd "<home>")    'beginning-of-buffer) ; M-<
(define-key my-keys-minor-mode-map (kbd "<end>")     'end-of-buffer)       ; M->

;; (require 'point-stack)
;; (load "~/.emacs.d/pointhistory.el")
;; (setq pointhistory-save-at-jump-width 10)
;; (define-key my-keys-minor-mode-map (kbd "<prior>")
;;   '(lambda ()
;;      (interactive)
;;   )
;; (define-key my-keys-minor-mode-map (kbd "<next>")
;;   '(lambda ()
;;      (interactive)
;;   )

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; (defadvice load (after give-my-keybindings-priority)
;;   "Try to ensure that my keybindings always have priority."
(defun force-my-keys-minor-mode ()
  (interactive)
  (if (not (eq (car (car minor-mode-map-alist)) 'my-keys-minor-mode))
      (let ((mykeys (assq 'my-keys-minor-mode minor-mode-map-alist)))
        (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist)
        (add-to-list 'minor-mode-map-alist mykeys)))
  )
;; (ad-activate 'load)

(load custom-file)

(message "My .emacs loaded in %ds"
         (destructuring-bind (hi lo ms ps) (current-time)
           (- (+ hi lo) (+ (first *emacs-load-start*)
                           (second *emacs-load-start*))))
         )
(put 'narrow-to-region 'disabled nil)
