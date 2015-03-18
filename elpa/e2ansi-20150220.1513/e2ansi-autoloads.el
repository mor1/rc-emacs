;;; e2ansi-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "e2ansi" "e2ansi.el" (21738 21019 0 0))
;;; Generated autoloads from e2ansi.el

(autoload 'e2ansi-view-buffer "e2ansi" "\
Display the e2ansi representation of the selected buffer.

\(fn)" t nil)

(autoload 'e2ansi-write-file "e2ansi" "\
Save the e2ansi representation of the current buffer to the file FILE-NAME.

Unless a name is given, the file will be named xxx.ansi, where
xxx is the file name associated with the buffer.

If CONFIRM is non-nil, ask for confirmation before overwriting an
existing file. Interactively, confirmation is required unless you
supply a prefix argument.

\(fn &optional FILE-NAME CONFIRM)" t nil)

(autoload 'e2ansi-batch-convert "e2ansi" "\
Convert the remaining files on the command line to ANSI format.

\(fn)" nil nil)

(autoload 'e2ansi-print-buffer "e2ansi" "\
Convert content of BUFFER to ANSI and print to DEST.

\(fn &optional BUFFER DEST)" nil nil)

;;;***

;;;### (autoloads nil nil ("e2ansi-list.el" "e2ansi-magic.el" "e2ansi-pkg.el"
;;;;;;  "e2ansi-silent.el") (21738 21019 81850 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; e2ansi-autoloads.el ends here
