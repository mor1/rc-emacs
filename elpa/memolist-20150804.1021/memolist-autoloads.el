;;; memolist-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "memolist" "memolist.el" (21964 52233 0 0))
;;; Generated autoloads from memolist.el

(autoload 'memolist-memo-new "memolist" "\
Create new markdown file in `memolist-memo-directory'.
If already same file was created, ask whether overwrite it or edit it.
And when same file does not exist, create new markdown file.

\(fn TITLE TAGS)" t nil)

(autoload 'memolist-show-list "memolist" "\
Show markdown file which placed in `memolist-memo-directory'.

\(fn)" t nil)

(autoload 'memolist-memo-grep "memolist" "\
Search contents of markdown file by `expr'.

\(fn EXPR)" t nil)

(autoload 'memolist-memo-grep-tag "memolist" "\
Search tags in markdown file by `tag'.

\(fn TAG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; memolist-autoloads.el ends here
