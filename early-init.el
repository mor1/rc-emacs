(defconst emacs-start-time (current-time))
(setq initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)
(add-hook
 'after-init-hook
 #'(lambda ()
     (setq gc-cons-threshold initial-gc-threshold)) ; restore after startup
 )

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)
(setq inhibit-startup-echo-area-message (user-login-name))
(setq frame-resize-pixelwise t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq
 default-frame-alist
 '((vertical-scroll-bars)
   (vertical-scroll-bars . nil) (horizontal-scroll-bars . nil)

   ;; (background-color . "#000000") ;; prevents flashes of color as the theme
   ;; (foreground-color . "#ffffff") ;; gets activated

   (ns-appearance . dark) (ns-transparent-titlebar . t)))
(setq package-enable-at-startup nil)
