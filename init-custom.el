(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.5)
 '(ac-trigger-key "C-.")
 '(auto-hscroll-mode nil)
 '(bibtex-autokey-titleword-separator ".")
 '(bibtex-autokey-year-title-separator ":")
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(comment-auto-fill-only-comments t)
 '(custom-safe-themes
   (quote
    ("0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(default-major-mode (quote text-mode) t)
 '(direnv-mode t nil (direnv))
 '(fci-rule-width 2)
 '(fill-column 80)
 '(frame-title-format "%b  %f" t)
 '(global-hl-line-mode t)
 '(global-visual-line-mode t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(holiday-bahai-holidays nil)
 '(holiday-general-holidays
   (quote
    ((holiday-fixed 1 1 "New Year's Day")
     (holiday-new-year-bank-holiday)
     (holiday-fixed 2 14 "Valentine's Day")
     (holiday-fixed 3 17 "St. Patrick's Day")
     (holiday-fixed 4 1 "April Fools' Day")
     (holiday-easter-etc -21 "Mother's Day")
     (holiday-easter-etc 1 "Easter Monday")
     (holiday-float 5 1 1 "Early May Bank Holiday")
     (holiday-float 5 1 -1 "Spring Bank Holiday")
     (holiday-float 6 0 3 "Father's Day")
     (holiday-float 8 1 -1 "Summer Bank Holiday")
     (holiday-fixed 10 31 "Halloween")
     (holiday-fixed 12 24 "Christmas Eve")
     (holiday-fixed 12 26 "Boxing Day")
     (holiday-christmas-bank-holidays)
     (holiday-fixed 12 31 "New Year's Eve"))))
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
 '(js-indent-level 2)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(mouse-buffer-menu-mode-mult 1)
 '(mu4e-confirm-quit nil)
 '(mu4e-date-format-long "%FT%T%z")
 '(mu4e-headers-long-date-format "%F%FT%z")
 '(mu4e-headers-time-format "%F%FT%z")
 '(mu4e-maildir "/Users/mort/me/footprint/mail")
 '(mu4e-update-interval nil)
 '(mu4e-use-fancy-chars t)
 '(mu4e-user-mail-address-list
   (quote
    ("mort@cantab.net" "mort@live.co.uk" "mort@microsoft.com" "mort@sprintlabs.com" "mort@vipadia.com" "richard.mortier@cl.cam.ac.uk" "richard.mortier@gmail.com" "richard.mortier@hotmail.com" "richard.mortier@nottingham.ac.uk" "richard.mortier@unikernel.com" "rmm1002@cam.ac.uk" "rmm1002@hermes.cam.ac.uk" "rmm@cs.nott.ac.uk")))
 '(mu4e-view-show-addresses t)
 '(next-screen-context-lines 0)
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(ns-function-modifier (quote hyper))
 '(org-agenda-files
   (quote
    ("/Users/mort/me/todo/todo.org" "/Users/mort/Dropbox/people/family.org/birthdays.org" "/Users/mort/Dropbox/people/family.org/birthdaysprint2019.org" "/Users/mort/Dropbox/people/family.org/birthdaysprint2020.org" "/Users/mort/Dropbox/people/family.org/david.org" "/Users/mort/Dropbox/people/family.org/eleanor.org" "/Users/mort/Dropbox/people/family.org/family.org" "/Users/mort/Dropbox/people/family.org/foodplans.org" "/Users/mort/Dropbox/people/family.org/holidays.org" "/Users/mort/Dropbox/people/family.org/homejournal.org" "/Users/mort/Dropbox/people/family.org/housework.org" "/Users/mort/Dropbox/people/family.org/packinglists.org" "/Users/mort/Dropbox/people/family.org/william.org")))
 '(org-clock-continuously t)
 '(package-selected-packages
   (quote
    (solarized-theme outshine mu4e-conversation mu4e-query-fragments ialign merlin-eldoc ansible terraform terraform-mode flycheck-css-colorguard flycheck-cython flycheck-lilypond flycheck-mypy auto-compile c-eldoc css-eldoc go-eldoc php-eldoc mu4e-maildirs-extension unfill org visual-line adaptive-wrap mu4e yaml-mode web-mode web-completion-data vline visual-fill-column utop use-package unkillable-scratch unbound tuareg syslog-mode simple-call-tree rainbow-mode protobuf-mode popup pointback php-mode pcsv paradox on-screen magithub latex-preview-pane latex-pretty-symbols jekyll-modes irony indium go-mode gitignore-mode gitconfig git-timemachine git-ps1-mode gh fm flycheck fill-column-indicator exec-path-from-shell elfeed dockerfile-mode direnv diminish csv-mode coffee-mode avy auto-package-update auctex aggressive-indent)))
 '(paradox-github-token t)
 '(require-final-newline (quote visit-save))
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(solarized-distinct-fringe-background t)
 '(solarized-scale-org-headlines nil)
 '(solarized-scale-outline-headlines nil)
 '(solarized-use-variable-pitch nil)
 '(tab-width 4)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(unkillable-scratch t)
 '(vc-follow-symlinks t)
 '(visible-bell t)
 '(visual-line-fringe-indicators (quote (right-triangle right-curly-arrow)))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-sql-indent-offset 2)
 '(web-mode-tests-directory "/Users/mort/teaching/ia.os/www/tests/"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-current-diff-C ((t (:background "yellow1"))))
 '(flyspell-duplicate ((t (:underline (:color "#b58900" :style wave)))))
 '(flyspell-incorrect ((t (:background "#aa0000" :foreground "gray75" :underline (:color "#dc322f" :style wave)))))
 '(smerge-base ((t (:background "lavender"))))
 '(whitespace-line ((t (:underline t))))
 '(whitespace-tab ((t (:foreground "burlywood3" :inverse-video t)))))
