;;; oauth2-request-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "oauth2-request" "oauth2-request.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from oauth2-request.el

(autoload 'oauth2-request "oauth2-request" "\
OAuth2 `request', enhanced `oauth2-url-retrieve'.

TOKEN is `oauth2-token'.  ARGS are `request' argument.
  (URL &rest settings
             &key
             (params nil)
             (data nil)
             (headers nil)
             (encoding 'utf-8)
             (error nil)
             (sync nil)
             (response (make-request-response))
             &allow-other-keys).

\(fn TOKEN URL &rest ARGS)" nil nil)

(function-put 'oauth2-request 'lisp-indent-function '2)

(autoload 'oauth2-request-synchronously "oauth2-request" "\
OAuth2 `request', enhanced `oauth2-url-retrieve-synchronously'.
See `oauth2-request' for TOKEN, URL, ARGS documentation.

\(fn TOKEN URL &rest ARGS)" nil nil)

(register-definition-prefixes "oauth2-request" '("oauth2-request-plist-get"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; oauth2-request-autoloads.el ends here
