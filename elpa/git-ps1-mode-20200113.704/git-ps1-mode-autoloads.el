;;; git-ps1-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "git-ps1-mode" "git-ps1-mode.el" (0 0 0 0))
;;; Generated autoloads from git-ps1-mode.el

(defvar git-ps1-mode nil "\
Non-nil if Git-Ps1 mode is enabled.
See the `git-ps1-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `git-ps1-mode'.")

(custom-autoload 'git-ps1-mode "git-ps1-mode" nil)

(autoload 'git-ps1-mode "git-ps1-mode" "\
Minor-mode to print __git_ps1.

This is a minor mode.  If called interactively, toggle the
`Git-Ps1 mode' mode.  If the prefix argument is positive, enable
the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='git-ps1-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'git-ps1-mode-get-current "git-ps1-mode" "\
Return current __git_ps1 execution output as string.

Give FORMAT if you want to specify other than \"%s\".
If optional argument DIR is given, run __git_ps1 in that directory.
This function returns nil if the output is not available for some reasons.

\(fn &optional FORMAT DIR)" nil nil)

(register-definition-prefixes "git-ps1-mode" '("git-ps1-mode-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; git-ps1-mode-autoloads.el ends here
