;;; point-stack-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "point-stack" "point-stack.el" (21986 8493
;;;;;;  0 0))
;;; Generated autoloads from point-stack.el

(autoload 'point-stack-push "point-stack" "\
Push current buffer, point, and scroll position onto stack.

\(fn)" t nil)

(autoload 'point-stack-pop "point-stack" "\
Push current location onto forward stack, move to previous location.

\(fn)" t nil)

(autoload 'point-stack-forward-stack-pop "point-stack" "\
Push current location onto stack, pop and move to location from forward stack.

\(fn)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; point-stack-autoloads.el ends here
