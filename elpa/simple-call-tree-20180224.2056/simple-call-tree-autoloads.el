;;; simple-call-tree-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "simple-call-tree" "simple-call-tree.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from simple-call-tree.el

(autoload 'simple-call-tree-display-buffer "simple-call-tree" "\
Display call tree for current buffer.
If optional arg FILES is supplied it specifies a list of files to search for 
functions to display in the tree. When called interactively with a prefix arg, 
files will be prompted for and only functions in the current buffer will be used.

\(fn &optional FILES)" t nil)

(autoload 'simple-call-tree-build-tree "simple-call-tree" "\
Build the simple-call-tree and display it in the \"*Simple Call Tree*\" buffer.
If BUFFERS is supplied it should be a list of buffer to analyze, otherwise the buffers
listed in `simple-call-tree-buffers' will be used.

\(fn &optional BUFFERS)" t nil)

(autoload 'simple-call-tree-current-function "simple-call-tree" "\
Display call tree for function FUNC.
If called interactively FUNC will be set to the symbol nearest point,
unless a prefix arg is used in which case the function returned by `which-function'
will be used.
Note: `which-function' may give incorrect results if `imenu' has not been used in
the current buffer.
If a call tree containing FUNC has not already been created then the user is prompted
for which files to build the tree from.

If optional arg WIDE is non-nil then the *Simple Call Tree* buffer will be widened,
otherwise it will be narrowed around FUNC.

\(fn FUNC &optional WIDE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "simple-call-tree" '("simple-call-tree-" "while")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; simple-call-tree-autoloads.el ends here
