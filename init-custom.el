(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#708183" "#c60007" "#728a05" "#a57705" "#2075c7" "#c61b6e" "#259185" "#042028"))
 '(auto-hscroll-mode nil)
 '(bibtex-autokey-titleword-separator ".")
 '(bibtex-autokey-year-title-separator ":")
 '(c-basic-offset 4)
 '(c-default-style
   (quote
    ((java-mode . "java")
     (awk-mode . "awk")
     (other . "linux"))))
 '(calendar-bahai-all-holidays-flag nil)
 '(calendar-christian-all-holidays-flag t)
 '(calendar-date-style (quote iso))
 '(calendar-mark-holidays-flag t)
 '(coffee-command "/usr/local/bin/coffee")
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(custom-theme-load-path
   (quote
    ("/Users/mort/.emacs.d/elpa/solarized-theme-20141030.1052/" custom-theme-directory t)))
 '(default-major-mode (quote text-mode) t)
 '(fci-rule-color "#0a2832")
 '(fci-rule-width 2)
 '(fill-column 80)
 '(frame-title-format "%b  %f" t)
 '(holiday-bahai-holidays nil)
 '(holiday-hebrew-holidays nil)
 '(holiday-islamic-holidays nil)
 '(holiday-oriental-holidays nil)
 '(holiday-other-holidays
   (quote
    ((holiday-float 1 1 3 "Martin Luther King Day")
     (holiday-float 2 1 3 "President's Day")
     (holiday-float 5 1 -1 "Memorial Day")
     (holiday-fixed 7 4 "Independence Day")
     (holiday-float 9 1 1 "Labor Day")
     (holiday-float 10 1 2 "Columbus Day")
     (holiday-fixed 11 11 "Veteran's Day")
     (holiday-float 11 4 4 "Thanksgiving"))))
 '(indent-tabs-mode nil)
 '(interprogram-paste-function (quote x-selection-value) t)
 '(linum-delay t)
 '(magit-diff-refine-hunk (quote all))
 '(magit-process-connection-type nil)
 '(magit-process-popup-time 5)
 '(magit-set-upstream-on-push t)
 '(make-backup-files nil)
 '(mouse-buffer-menu-mode-mult 1)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-progressive-speed t)
 '(mouse-wheel-scroll-amount (quote (5 ((control) . 1))))
 '(msb-max-file-menu-items 1)
 '(msb-max-menu-items 35)
 '(msb-mode t)
 '(nobreak-char-display t t)
 '(ns-alternate-modifier (quote super))
 '(ns-command-modifier (quote meta))
 '(ns-function-modifier (quote hyper))
 '(nxml-slash-auto-complete-flag t)
 '(ocp-indent-syntax (quote ("lwt" "cstruct")))
 '(org-agenda-files (quote ("~/me/todo/todo.org")))
 '(org-agenda-include-diary t)
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-sorting-strategy (quote (time-up priority-down)))
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-default-notes-file "~/me/todo/notes.org")
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-remember-store-without-prompt t)
 '(org-remember-templates
   (quote
    ((116 "* %? %u" "~/me/todo/todo.org" "Tasks")
     (110 "* %u %?" "~/me/todo/notes.org" "Notes"))))
 '(org-reverse-note-order t)
 '(org-tags-match-list-sublevels t)
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler)))
 '(safe-local-variable-values (quote ((TeX-master . "propB"))))
 '(scroll-conservatively 100)
 '(scroll-preserve-screen-position 1)
 '(scroll-step 1)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#c60007")
     (40 . "#bd3612")
     (60 . "#a57705")
     (80 . "#728a05")
     (100 . "#259185")
     (120 . "#2075c7")
     (140 . "#c61b6e")
     (160 . "#5859b7")
     (180 . "#c60007")
     (200 . "#bd3612")
     (220 . "#a57705")
     (240 . "#728a05")
     (260 . "#259185")
     (280 . "#2075c7")
     (300 . "#c61b6e")
     (320 . "#5859b7")
     (340 . "#c60007")
     (360 . "#bd3612"))))
 '(vc-annotate-very-old-color nil)
 '(vc-follow-symlinks t)
 '(visible-bell t)
 '(visual-line-fringe-indicators (quote (right-triangle right-curly-arrow)))
 '(whitespace-style
   (quote
    (face trailing tabs lines space-before-tab newline empty tab-mark)))
 '(x-select-enable-clipboard t)
 '(x-stretch-cursor t))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background "#042028" :foreground "lightslategrey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "apple" :family "Consolas")))))

;; (with-temp-buffer
;;   (insert
;;    (shell-command-to-string "ocp-edit-mode emacs -load-global-config")
;;    )
;;   (eval-buffer)
;;   )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
