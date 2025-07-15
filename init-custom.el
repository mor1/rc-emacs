(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.5)
 '(ac-trigger-key "C-.")
 '(auto-hscroll-mode 'current-line)
 '(before-save-hook nil)
 '(bibtex-autokey-titleword-separator ".")
 '(bibtex-autokey-year-title-separator ":")
 '(c-basic-offset 2)
 '(column-number-mode t)
 '(comment-auto-fill-only-comments t)
 '(custom-safe-themes
    '("7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
       "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c"
       "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3"
       "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f"
       "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0"
       "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347"
       "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4"
       "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328"
       default))
 '(default-frame-alist '((vertical-scroll-bars)))
 '(default-major-mode 'text-mode t)
 '(direnv-mode t nil (direnv))
 '(display-time-day-and-date t)
 '(epg-pinentry-mode 'loopback)
 '(fci-rule-width 2)
 '(fill-column 80)
 '(frame-title-format "%b  %f" t)
 '(global-hl-line-mode t)
 '(global-visual-line-mode t)
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
    (--map (solarized-color-blend it "#002b36" 0.25)
      '("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2")))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
    '(("#073642" . 0) ("#546E00" . 20) ("#00736F" . 30) ("#00629D" . 50)
       ("#7B6000" . 60) ("#8B2C02" . 70) ("#93115C" . 85) ("#073642" . 100)))
 '(holiday-bahai-holidays nil)
 '(holiday-general-holidays
    '((holiday-fixed 1 1 "New Year's Day") (holiday-new-year-bank-holiday)
       (holiday-fixed 2 14 "Valentine's Day")
       (holiday-fixed 3 17 "St. Patrick's Day")
       (holiday-fixed 4 1 "April Fools' Day")
       (holiday-easter-etc -21 "Mothering Sunday")
       (holiday-easter-etc 1 "Easter Monday")
       (holiday-float 5 1 1 "Early May Bank Holiday")
       (holiday-float 5 1 -1 "Spring Bank Holiday")
       (holiday-float 6 0 3 "Father's Day")
       (holiday-float 8 1 -1 "Summer Bank Holiday")
       (holiday-fixed 10 31 "Halloween") (holiday-fixed 12 24 "Christmas Eve")
       (holiday-fixed 12 26 "Boxing Day") (holiday-christmas-bank-holidays)
       (holiday-fixed 12 31 "New Year's Eve")))
 '(holiday-hebrew-holidays nil)
 '(holiday-islamic-holidays nil)
 '(holiday-oriental-holidays nil)
 '(holiday-other-holidays
    '((holiday-float 1 1 3 "Martin Luther King Day")
       (holiday-float 2 1 3 "President's Day")
       (holiday-float 5 1 -1 "Memorial Day")
       (holiday-fixed 7 4 "Independence Day") (holiday-float 9 1 1 "Labor Day")
       (holiday-float 10 1 2 "Columbus Day")
       (holiday-fixed 11 11 "Veteran's Day")
       (holiday-float 11 4 4 "Thanksgiving")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-frame-alist '((top . 1) (left . 1) (width . 170) (height . 80)))
 '(interprogram-paste-function 'x-selection-value t)
 '(lisp-indent-offset 2)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(mouse-buffer-menu-mode-mult 1)
 '(mu4e-compose-complete-only-after "nil")
 '(mu4e-compose-complete-only-personal t)
 '(mu4e-confirm-quit nil)
 '(mu4e-date-format-long "%FT%T%z")
 '(mu4e-headers-long-date-format "%F%FT%z")
 '(mu4e-headers-time-format "%F%FT%z")
 '(mu4e-maildir "/Users/mort/me/footprint/mail" t)
 '(mu4e-update-interval nil)
 '(mu4e-use-fancy-chars t)
 '(mu4e-user-mail-address-list
    '("mort@cantab.net" "mort@live.co.uk" "mort@microsoft.com" "mort@sprintlabs.com"
       "mort@vipadia.com" "richard.mortier@cl.cam.ac.uk"
       "richard.mortier@gmail.com" "richard.mortier@hotmail.com"
       "richard.mortier@nottingham.ac.uk" "richard.mortier@unikernel.com"
       "rmm1002@cam.ac.uk" "rmm1002@hermes.cam.ac.uk" "rmm@cs.nott.ac.uk"))
 '(mu4e-view-show-addresses t)
 '(next-screen-context-lines 0)
 '(ns-alternate-modifier 'none)
 '(ns-command-modifier 'meta)
 '(ns-function-modifier 'hyper)
 '(package-selected-packages
    '(adaptive-wrap aggressive-indent async auctex auto-compile auto-package-update
       balanced-windows c-eldoc clojure-mode coffee-mode css-eldoc direnv
       dockerfile-mode eldoc elfeed elisp-autofmt exec-path-from-shell
       fill-column-indicator filladapt flycheck-cython flycheck-lilypond
       flycheck-mypy fm git-ps1-mode git-timemachine gitconfig gitignore-mode
       go-eldoc go-mode ialign ido-completing-read+ jekyll-modes just-mode
       latex-preview-pane magithub markdown-mode mu4e mu4e-conversation
       mu4e-maildirs-extension mu4e-query-fragments nix-mode nix-modeline
       nixos-options ocaml-eglot on-screen org org-gcal paredit pcsv php-eldoc
       php-mode pointback protobuf-mode rainbow-mode rjsx-mode simple-call-tree
       solarized-theme terraform tide tuareg typescript-mode unbound
       unkillable-scratch use-package visual-fill-column visual-line vline))
 '(paradox-github-token t)
 '(require-final-newline 'visit-save)
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
 '(uniquify-buffer-name-style 'post-forward-angle-brackets nil (uniquify))
 '(unkillable-scratch t)
 '(vc-follow-symlinks t)
 '(visible-bell t)
 '(visual-line-fringe-indicators '(right-triangle right-curly-arrow))
 '(whitespace-line-column nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 90 :width normal :foundry "PfEd" :family "Atkinson Hyperlegible Mono"))))
 '(ediff-current-diff-C ((t (:background "yellow1"))))
 '(flyspell-duplicate ((t (:underline (:color "#b58900" :style wave)))))
 '(flyspell-incorrect ((t (:background "#aa0000" :foreground "gray75" :underline (:color "#dc322f" :style wave)))))
 '(highlight ((t (:background "dark slate gray"))))
 '(smerge-base ((t (:background "lavender"))))
 '(whitespace-line ((t (:foreground unspecified :underline "OrangeRed3"))))
 '(whitespace-tab ((t (:foreground "burlywood4" :inverse-video t)))))
