(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.5)
 '(ac-trigger-key "C-TAB")
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
 '(comment-auto-fill-only-comments t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(default-input-method nil)
 '(default-major-mode (quote text-mode) t)
 '(fci-handle-truncate-lines nil)
 '(fci-rule-width 2)
 '(fill-column 80)
 '(frame-title-format "%b  %f" t)
 '(gc-cons-threshold 80000000)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
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
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((top . 1) (left . 1) (width . 170) (height . 80))))
 '(interprogram-paste-function (quote x-selection-value) t)
 '(linum-delay t)
 '(magit-diff-refine-hunk (quote all))
 '(magit-diff-use-overlays nil)
 '(magit-process-connection-type nil)
 '(magit-process-popup-time 5)
 '(magit-set-upstream-on-push t)
 '(magit-use-overlays nil)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(mouse-buffer-menu-mode-mult 1)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-progressive-speed t)
 '(mouse-wheel-scroll-amount (quote (5 ((control) . 1))))
 '(msb-max-file-menu-items 1)
 '(msb-max-menu-items 35)
 '(msb-mode t)
 '(mu4e-confirm-quit nil)
 '(mu4e-date-format-long "%FT%T%z")
 '(mu4e-headers-long-date-format "%F%FT%z")
 '(mu4e-headers-time-format "%F%FT%z")
 '(mu4e-maildir "/Users/mort/me/footprint/mail")
 '(mu4e-use-fancy-chars t)
 '(mu4e-user-mail-address-list
   (quote
    ("mort@cantab.net" "mort@live.co.uk" "mort@microsoft.com" "mort@sprintlabs.com" "mort@vipadia.com" "richard.mortier@cl.cam.ac.uk" "richard.mortier@gmail.com" "richard.mortier@hotmail.com" "richard.mortier@nottingham.ac.uk" "richard.mortier@unikernel.com" "rmm1002@cam.ac.uk" "rmm1002@hermes.cam.ac.uk" "rmm@cs.nott.ac.uk")))
 '(mu4e-view-show-addresses t)
 '(next-screen-context-lines 0)
 '(nobreak-char-display t t)
 '(notmuch-hello-sections
   (quote
    (notmuch-hello-insert-header notmuch-hello-insert-saved-searches notmuch-hello-insert-inbox notmuch-hello-insert-search notmuch-hello-insert-recent-searches notmuch-hello-insert-alltags notmuch-hello-insert-footer)))
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(ns-function-modifier (quote hyper))
 '(nxml-slash-auto-complete-flag t)
 '(ocp-indent-syntax (quote ("lwt" "cstruct")))
 '(org-agenda-files (quote ("~/me/todo/todo.org")))
 '(org-agenda-include-diary t)
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-sorting-strategy
   (quote
    (time-up todo-state-down category-keep priority-down alpha-down)))
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
 '(package-selected-packages
   (quote
    (magit magit-popup yasnippet yaml-mode web-mode web-completion-data vline vlf utop use-package unkillable-scratch unfill unbound tuareg syslog-mode smart-tab rainbow-mode rainbow-delimiters protobuf-mode popup pointback point-stack php-mode pcsv paradox on-screen names merlin memolist latex-preview-pane latex-pretty-symbols irony interleave gscholar-bibtex go-mode gitignore-mode gitconfig git-timemachine git-ps1-mode gh flycheck fill-column-indicator elfeed e2ansi dockerfile-mode diff-hl diff-git d-mode company color-theme-sanityinc-solarized color-theme coffee-mode bbdb bash-completion avy auctex aggressive-indent)))
 '(paradox-github-token t)
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler)))
 '(safe-local-variable-values
   (quote
    ((TeX-master . "flick-eurosys16")
     (TeX-master . "naasbox-sosp15")
     (TeX-master . t)
     (TeX-master . "propB"))))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 100)
 '(scroll-error-top-bottom t)
 '(scroll-preserve-screen-position t)
 '(scroll-step 0)
 '(select-enable-clipboard t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(size-indication-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(tab-width 4)
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(unkillable-scratch t)
 '(vc-follow-symlinks t)
 '(visible-bell t)
 '(visual-line-fringe-indicators (quote (right-triangle right-curly-arrow)))
 '(web-mode-attr-indent-offset 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-sql-indent-offset 2)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496")))
 '(whitespace-style
   (quote
    (face trailing tabs lines space-before-tab newline empty tab-mark)))
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
 '(whitespace-line ((t (:underline t)))))
