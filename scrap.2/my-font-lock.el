;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; $Id: my-font-lock.el,v 1.2 2008/06/20 15:12:36 mort Exp mort $
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ripped from random font-lock.el found on web since no longer
;; appears to be defined in font-lock.el, emacs-carbon-22.0.50

;; Regexp matches after point:		word<word>::word (
;;						^^^^ ^^^^   ^^^^ ^
;; Where the match subexpressions are:	  1    3      5  6
;;
;; Item is delimited by (match-beginning 1) and (match-end 1).  
;; If (match-beginning 3) is non-nil, that part of the item incloses a `<>'.
;; If (match-beginning 5) is non-nil, that part of the item follows a `::'.
;; If (match-beginning 6) is non-nil, the item is followed by a `('.
(defun font-lock-match-c++-style-declaration-item-and-skip-to-next (limit)
  (when (looking-at 
         (eval-when-compile
           (concat
            ;; Skip any leading whitespace.
            "[ \t\n*&]*"
            ;; This is `c++-type-spec' from below.  (Hint hint!)
            "\\(\\sw+\\)"				; The instance?
            "\\([ \t\n]*<\\(\\(?:[^<>]\\|<[^>]+>\\)+\\)[ \t\n*&]*>\\)?"	; Or template?
            "\\([ \t\n]*::[ \t\n*~]*\\(\\sw+\\)\\)*"	; Or member?
            ;; Match any trailing parenthesis.
            "[ \t\n]*\\((\\)?")))
    (save-match-data
      (condition-case nil
	  (save-restriction
	    ;; Restrict to the end of line, currently guaranteed to be LIMIT.
	    (narrow-to-region (point-min) limit)
	    (goto-char (match-end 1))
	    ;; Move over any item value, etc., to the next item.
	    (while (not (looking-at "[ \t\n]*\\(\\(,\\)\\|;\\|\\'\\)"))
	      (goto-char (or (scan-sexps (point) 1) (point-max))))
	    (goto-char (match-end 2)))
	(error t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Get some decent colours set up

(setq font-lock-face-attributes
      '((font-lock-comment-face       "Goldenrod")
        (font-lock-string-face        "turquoise")
        (font-lock-keyword-face       "gold")
        (font-lock-function-name-face "green")
        (font-lock-prototype-face     "palegreen")
        (font-lock-globals-face       "orange")
        (font-lock-variable-name-face "LightGoldenrod")
        (font-lock-type-face          "orange")
;        (font-lock-reference-face     "Aquamarine")
        (font-lock-preproc-face       "aquamarine") ; used by my c-mode
        (font-lock-define-face        "aquamarine") ; ditto
        (font-lock-alarm-face         "red")        ; ditto
        (font-lock-faded-face         "slategray")  ; ditto
        (font-lock-TRC-face           "seagreen3")  ; ditto
	;; Message colors 
        (msg-subject-face             "gold")
        (msg-from-face                "Green")
        (msg-to-face                  "RosyBrown1")
        (msg-cc-face                  "turquoise")
        (msg-separator-face           "Black" "LightBlue")
        (msg-header-face              "seagreen3")
        (msg-quoter2-face             "pink")
        (msg-quoter-face              "goldenrod")
        (msg-quote2-face              "pink")
        (msg-quote-face               "goldenrod")
	;;
        (mh-deleted-face              "red")
        (mh-unseen-face               "green")
        (mh-refiled-face              "turquoise")
        (mh-current-face              "wheat")
        (mh-pending-face              "seagreen1")
        (mh-replied-face              "khaki3")
        (mh-forwarded-face            "orange")
        (mh-sequence-face             "purple")
        (mh-urgent-face               "gold" "red")
	))

;; Force a load now, to define font-lock-fontify-region
(load "font-lock")

;; Turn on font-lock mode whenever supported
(global-font-lock-mode 1)

;; Go for lazy font locking
;(setq font-lock-support-mode 'lazy-lock-mode)

;; Fontify everything up to the back teeth
(setq font-lock-maximum-decoration t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; My C stuff; copied from font-lock.el, and hacked around

(let ((c-keywords
;      ("break" "continue" "do" "else" "for" "if" "return" "switch" "while")
       "break\\|continue\\|do\\|else\\|for\\|if\\|return\\|switch\\|while")
      (c-type-types
;      ("auto" "extern" "register" "static" "typedef" "struct" "union" "enum"
;	"signed" "unsigned" "short" "long" "int" "char" "float" "double"
;	"void" "volatile" "const")
       (concat "\\w+_t\\|auto\\|c\\(har\\|onst\\)\\|double\\|e\\(num\\|xtern\\)\\|"
	       "float\\|int\\|long\\|register\\|"
	       "s\\(hort\\|igned\\|t\\(atic\\|ruct\\)\\)\\|typedef\\|"
	       "un\\(ion\\|signed\\)\\|vo\\(id\\|latile\\)"))	; 6 ()s deep.
      (c++-keywords
;      ("break" "continue" "do" "else" "for" "if" "return" "switch" "while"
;	"asm" "catch" "delete" "new" "operator" "sizeof" "this" "throw" "try"
;       "protected" "private" "public")
       (concat "asm\\|break\\|c\\(atch\\|ontinue\\)\\|d\\(elete\\|o\\)\\|"
	       "else\\|for\\|if\\|new\\|"
	       "p\\(r\\(ivate\\|otected\\)\\|ublic\\)\\|return\\|"
	       "s\\(izeof\\|witch\\)\\|t\\(h\\(is\\|row\\)\\|ry\\)\\|while"))
      (c++-type-types
;      ("auto" "extern" "register" "static" "typedef" "struct" "union" "enum"
;	"signed" "unsigned" "short" "long" "int" "char" "float" "double"
;	"void" "volatile" "const" "class" "inline" "friend" "bool"
;	"virtual" "complex" "template")
       (concat "FILE\\|auto\\|bool\\|c\\(har\\|lass\\|o\\(mplex\\|nst\\)\\)\\|"
	       "double\\|e\\(num\\|xtern\\)\\|f\\(loat\\|riend\\)\\|"
	       "in\\(line\\|t\\)\\|long\\|register\\|"
	       "s\\(hort\\|igned\\|t\\(atic\\|ruct\\)\\)\\|"
	       "t\\(emplate\\|ypedef\\)\\|un\\(ion\\|signed\\)\\|"
	       "v\\(irtual\\|o\\(id\\|latile\\)\\)"))		; 11 ()s deep.
      )
 (setq myc-font-lock-keywords-1
  (list
   ;;
   ;; These are all anchored at the beginning of line for speed.
   ;;
   ;; Fontify function name definitions (GNU style; without type on line).
   (list (concat "^\\(\\sw+\\)[ \t]*(") 1 'font-lock-function-name-face)
   ;; Fontify function name definitions 
   (list (concat "^"
		 "\\(" "\\(extern\\|static\\)" "[ \t\n]+" "\\)?"
		 "\\(\\w+\\)" "[* \t\n]+" 
		 "\\(\\sw+\\)"
		 "[ \t\n]*"
		 "([a-zA-Z0-9_*, \t\n]*)[^;]") 0 'font-lock-function-name-face)
   (list (concat "^"
		 "\\(" "\\(extern\\|static\\)" "[ \t\n]+" "\\)?"
		 "\\(\\w+\\)" "[* \t]+" 
		 "\\(\\sw+\\)"
		 "[ \t\n]*"
		 "([a-zA-Z0-9_*, \t\n]*)[;]") 0 'font-lock-prototype-face)
   (list (concat "^"
		 "\\(" "\\(extern\\|static\\)" "[ \t\n]+" "\\)?"
		 "\\(\\w+\\)" "[* \t]+" 
		 "\\(\\sw+\\)"
		 "[ \t\n]*"
		 ".*[;]") 0 'font-lock-globals-face)
   ;;
   ;; Fontify filenames in #include <...> preprocessor directives as strings.
   '("^#[ \t]*include[ \t]+\\(<[^>\"\n]+>\\)" 1 font-lock-string-face)
   ;;
   ;; Fontify function macro names.
   '("^#[ \t]*define[ \t]+\\(\\(\\sw+\\)(\\)" 2 font-lock-function-name-face)
   ;;
   ;; #define's in green
   '("^\\(#[ \t]*define\\)[ \t]+" 1 font-lock-define-face)
   ;;
   ;; #if 0
   '("^#if 0.*[\n]\\([^#]*\\)\\(#endif.*\\|#else.*\\)" 1 font-lock-faded-face t)
   ;;
   ;; Fontify symbol names in #if ... defined preprocessor directives.
   '("^#[ \t]*if\\>"
     ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
      (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t)))
   ;;
   ;; Fontify otherwise as symbol names, and the preprocessor directive names.
   '("^\\(#[ \t]*[a-z]+\\)\\>[ \t]*\\(\\sw+\\)?"
     (1 font-lock-preproc-face) (2 font-lock-variable-name-face nil t))

   ;; XXX stuff (the 't' is the OVERRIDE existing font flag)
   '("XXX" 0 font-lock-alarm-face t)
   '("\\<\\(X[X]+\\)\\|\\(![!]+\\)\\>" 1 font-lock-alarm-face t)

   ;; 
   '("ENTER_KERNEL_CRITICAL_SECTION();" 0 font-lock-alarm-face t)
   '("LEAVE_KERNEL_CRITICAL_SECTION();" 0 font-lock-alarm-face t)

   ;; assertions
   '("\\(^[ \t]*ASSERT(.*)?\\)" 1 font-lock-alarm-face t)

   ;; TRC stuff
   '("\\([ \t]+ERROR(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\([ \t]+ERROREXIT(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\([ \t]+ERROREXITCLEANUP(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\([ \t]+SETERROREXIT(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\([ \t]+WARN(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\([ \t]+WARNARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+TRC(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+TRCARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)

   '("\\([ \t]+ENTER\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+LEAVE\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+RETURN\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+RETURNV\\)" 1 font-lock-TRC-face t)

   '("\\([ \t]+HEAPVALIDATE\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+HTRC(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\([ \t]+HTRCARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)

   '("\\(^ERROR(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\(^ERROREXIT(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\(^ERROREXITCLEANUP(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\(^SETERROREXIT(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\(^WARN(.*)?\\)" 1 font-lock-alarm-face t)
   '("\\(^WARNARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\(^TRC(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\(^TRCARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)

   '("\\(^ENTER\\)" 1 font-lock-TRC-face t)
   '("\\(^LEAVE\\)" 1 font-lock-TRC-face t)
   '("\\(^RETURN\\)" 1 font-lock-TRC-face t)
   '("\\(^RETURNV\\)" 1 font-lock-TRC-face t)

   '("\\(^HEAPVALIDATE\\)" 1 font-lock-TRC-face t)
   '("\\(^HTRC(.*)?\\)" 1 font-lock-TRC-face t)
   '("\\(^HTRCARG[0-9]*(.*)?\\)" 1 font-lock-TRC-face t)
   ))

 (setq myc-font-lock-keywords-2
  (append myc-font-lock-keywords-1
   (list
    ;;
    ;; Simple regexps for speed.
    ;;
    ;; Fontify all type specifiers.
    (cons (concat "\\<\\(" c-type-types "\\)\\>") 'font-lock-type-face)
    ;;
    ;; Fontify all builtin keywords (except case, default and goto; see below).
    (cons (concat "\\<\\(" c-keywords "\\)\\>") 'font-lock-keyword-face)
    ;;
    ;; Fontify case/goto keywords and targets, and case default/goto tags.
    '("\\<\\(case\\|goto\\)\\>[ \t]*\\([^ \t\n:;]+\\)?"
      (1 font-lock-keyword-face) (2 font-lock-reference-face nil t))
    '("^[ \t]*\\(\\sw+\\)[ \t]*:" 1 font-lock-reference-face)
    ;;
    )))




 (setq myc-font-lock-keywords-3
  (append myc-font-lock-keywords-2
   ;;
   ;; More complicated regexps for more complete highlighting for types.
   ;; We still have to fontify type specifiers individually, as C is so hairy.
   (list
    ;;
    ;; Fontify all storage classes and type specifiers, plus their items.
;    (list (concat "\\<\\(" c-type-types "\\)\\>"
;		  "\\([ \t*&]+\\sw+\\>\\)*")
;	  ;; Fontify each declaration item.
;	  '(font-lock-match-c++-style-declaration-item-and-skip-to-next
;	    ;; Start with point after all type specifiers.
;	    (goto-char (or (match-beginning 8) (match-end 1)))
;	    ;; Finish with point after first type specifier.
;	    (goto-char (match-end 1))
;	    ;; Fontify as a variable or function name.
;	    (1 (if (match-beginning 4)
;		   font-lock-function-name-face
;		 font-lock-variable-name-face))))
    ;;
    ;; Fontify structures, or typedef names, plus their items.
    '("\\(}\\)[ \t*]*\\sw"
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (match-end 1)) nil
       (1 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face))))
    ;;
    ;; Fontify anything at beginning of line as a declaration or definition.
    '("^\\(\\sw+\\)\\>\\([ \t*]+\\sw+\\>\\)*"
      (1 font-lock-type-face)
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (or (match-beginning 2) (match-end 1))) nil
       (1 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face))))
    )))
 )

(add-hook 'c-mode-hook
	  '(lambda ()
	     (make-local-variable 'font-lock-defaults)
	     (setq font-lock-defaults
		   '((c-font-lock-keywords 
		      myc-font-lock-keywords-1
		      myc-font-lock-keywords-2 
		      myc-font-lock-keywords-3
		      )
		     nil nil ((?_ . "w")) beginning-of-defun))
	     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Text mode stuff, for stuff like mail

(setq my-text-font-lock-keywords-1
      (list
       (list (concat "^\\(Subject:.*\\)$") 1 'font-lock-msg-subject-face)
       '("^\\(--text follows this line--\\)$" 1 font-lock-msg-separator-face)
       )
)

(setq my-text-font-lock-keywords-2
  (append my-text-font-lock-keywords-1
      (list
       '("^\\(From:.*\\)$" 1 font-lock-msg-from-face)
       '("^\\([A-Za-z][#A-Za-z0-9-]+:\\)" 1 font-lock-msg-header-face)
       )
      )
)

(setq my-text-font-lock-keywords-3
  (append my-text-font-lock-keywords-2
      (list
       '("^\\(In article.*\\)$" 1 font-lock-msg-quote-face)
       '("^\\([ \t]*\\w*[]<>}].*\\)$" 1 font-lock-msg-quote-face)
       )
      )
)

(defun my-text-mode-defaults ()
  "Set up font-lock patterns for text modes, eg mail news etc."
  (make-local-variable 'font-lock-defaults)
  (make-local-variable 'font-lock-maximum-size)
  (setq font-lock-maximum-size nil) ; turn off size check
  (setq font-lock-defaults
	'((my-text-font-lock-keywords-1 ; default
	   my-text-font-lock-keywords-1 ; level 1
	   my-text-font-lock-keywords-2 ; level 2
	   my-text-font-lock-keywords-3) ; level 3
	  t nil nil beginning-of-line))
)

(defun my-text-mode-and-fontify ()
  (my-text-mode-defaults)
  (turn-on-font-lock)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; mh-mode highlighting

(defvar mh-folder-mode-keywords
  ;; Column 5 marks
  '(("^....D..*$" 0 mh-deleted-face)
    ("^....\\^..*$" 0 mh-refiled-face)
    ("^....C..*$" 0 mh-refiled-face)
    ;; ("^....\\+.*$" 0 mh-current-face)
    ;; Column 6 marks
    ("^..... .*$" 0 mh-pending-face)
    ("^.....-.*$" 0 mh-replied-face)
    ("^.....F.*$" 0 mh-forwarded-face)
    ("^.....%.*$" 0 mh-sequence-face)
    ("^.....u..*$" 0 mh-unseen-face)
    ("^.....\\*.*$" 0 mh-urgent-face)
    ;; Messages which have been automatically added to sequences by 
    ;; .forward processing
    ("^.....%......nemesis.*$" 0 mh-refiled-face t)
    ("^.....%......linux.*$" 0 mh-refiled-face t)
    )
  "*Font-lock patterns for MH folder mode")
(defvar mh-letter-mode-keywords
  '(("^Subject:.*$"                 0 msg-subject-face)
    ("^From:.*$"                    0 msg-from-face)
    ("^To:.*$"                      0 msg-to-face)
    ("^Cc:.*$"                      0 msg-cc-face)
    ("^--text follows this line--$" 0 msg-separator-face)
    ("^[A-Za-z][A-Za-z0-9-]+:"      0 msg-header-face)
    ;;
    ("^\\([ \t]*\\w*[]>}|][ \t]*\\w*[]>}|]\\)+.*$" 0 msg-quote2-face)
    ("^\\([ \t]*\\w*[]>}|]\\)\\([ \t]*\\w*[]>}|][ \t]*\\w*[]>}|]\\)*.*$" 
     0 msg-quote-face)
    ("In article.*$" 0 msg-quoter-face)
    )    
  "*Font-lock patterns for MH letter mode")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ASM mode 

(defvar asm-mode-keywords
  (list
   ;;
   ;; Comments
   '("//.*$"      font-lock-comment-face)
   '("#.*$$"      font-lock-comment-face)
   '("/\\*.*\\*/$"  font-lock-comment-face)

   ;; Fontify filenames in #include <...> preprocessor directives as strings.
   '("^#[ \t]*include[ \t]+\\(<[^>\"\n]+>\\)" 1 font-lock-string-face)
   ;;
   ;; Fontify function macro names.
   '("^#[ \t]*define[ \t]+\\(\\(\\sw+\\)(\\)" 2 font-lock-function-name-face)
   ;;
   ;; #define's 
   '("^\\(#[ \t]*define\\)[ \t]+" 1 font-lock-define-face)
   ;;
   ;; #if 0
   '("^#if 0.*[\n]\\([^#]*\\)\\(#endif\\|#else\\)" 1 font-lock-faded-face t)
   ;;
   ;; Fontify symbol names in #if ... defined preprocessor directives.
   '("^#[ \t]*if\\>"
     ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
      (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t)))
   ;;
   ;; Fontify otherwise as symbol names, and the preprocessor directive names.
   '("^\\(#[ \t]*[a-z]+\\)\\>[ \t]*\\(\\sw+\\)?"
     (1 font-lock-preproc-face) (2 font-lock-variable-name-face nil t))

   ;; XXX stuff (the 't' is the OVERRIDE existing font flag)
   '("XXX" 0 font-lock-alarm-face t)
   '("\\*\\*+" 0 font-lock-alarm-face t)

   ;; TRC stuff
   '("\\([A-Z]*TRC(.*)?\\)" 1 font-lock-TRC-face t)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Some more goodies for font-lock-defaults-alist

;(setq 
; font-lock-defaults-alist
; (append
;  '((mh-folder-mode mh-folder-mode-keywords t nil nil beginning-of-line)
;    (mh-letter-mode mh-letter-mode-keywords t nil nil beginning-of-line)
;    (mh-show-mode   mh-letter-mode-keywords t nil nil beginning-of-line)
;    (asm-mode       asm-mode-keywords       t nil nil beginning-of-line)
;    )
;  font-lock-defaults-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; XXX ADD EVERYTHING BELOW HERE TO YOUR OWN INITIALISATION CODE XXX
;;;
;;; XXX, KAF: This is ripped from 19.34 font-lock.el.  It is needed to get 
;;; Emacs 20 to recognise our new faces.

(defun font-lock-make-face (face-attributes)
  (let* ((face (nth 0 face-attributes))
         (face-name (symbol-name face))
         (set-p (function (lambda (face-name resource)
                 (x-get-resource (concat face-name ".attribute" resource)
                                 (concat "Face.Attribute" resource)))))
         (on-p (function (lambda (face-name resource)
                (let ((set (funcall set-p face-name resource)))
                  (and set (member (downcase set) '("on" "true"))))))))
    (make-face face)
    (add-to-list 'facemenu-unlisted-faces face)
    (or (funcall set-p face-name "Foreground")
        (set-face-foreground face (nth 1 face-attributes)))
    (or (funcall set-p face-name "Background")
            (set-face-background face (nth 2 face-attributes)))
    (if (funcall set-p face-name "Bold")
        (and (funcall on-p face-name "Bold") (make-face-bold face nil t))
      (and (nth 3 face-attributes) (make-face-bold face nil t)))
    (if (funcall set-p face-name "Italic")
        (and (funcall on-p face-name "Italic") (make-face-italic face nil t))
      (and (nth 4 face-attributes) (make-face-italic face nil t)))
    (or (funcall set-p face-name "Underline")
        (set-face-underline-p face (nth 5 face-attributes)))
    (set face face)))
(mapcar '(lambda (face-attributes)
           (let ((face (nth 0 face-attributes)))
             (cond ((and (boundp face) (facep (symbol-value face))) nil)
                   ((facep face) (set face face))
                   (t (font-lock-make-face face-attributes)))))
        font-lock-face-attributes)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Get some decent colours set up
;(setq font-lock-face-attributes
;      '((font-lock-comment-face        "Salmon1")
;	(font-lock-string-face          "thistle3")
;	(font-lock-keyword-face         "SteelBlue2")
;	(font-lock-function-name-face   "slategray3")
;	(font-lock-prototype-face       "Slategray3")
;	(font-lock-globals-face         "blanchedAlmond")
;	(font-lock-variable-name-face   "LightGoldenrod")
;	(font-lock-type-face            "Gainsboro")
;	(font-lock-reference-face       "wheat2")
;	(font-lock-preproc-face         "Plum1")      ;; used by my c-mode
;	(font-lock-define-face          "Green3")     ;; ditto
;	(font-lock-alarm-face           "red")        ;; ditto
;	(font-lock-faded-face           "grey55")     ;; ditto
;	(font-lock-TRC-face             "RosyBrown1") ;; ditto
;	;; Message colors 
;	(font-lock-msg-subject-face     "RoyalBlue1")
;	(font-lock-msg-from-face        "Green")
;	(font-lock-msg-separator-face   "Black" "LightBlue")
;	(font-lock-msg-header-face      "IndianRed1")
;	(font-lock-msg-quote-face       "Pink")
;	))

;;      '((font-lock-comment-face         "SandyBrown")
;;        (font-lock-string-face          "orange")
;;        (font-lock-keyword-face         "SteelBlue2")
;;        (font-lock-function-name-face   "RoyalBlue1")
;;        (font-lock-prototype-face       "aquamarine")
;;        (font-lock-globals-face         "blanchedAlmond")
;;        (font-lock-variable-name-face   "LightGoldenrod")
;;        (font-lock-type-face            "Gainsboro")
;;        (font-lock-reference-face       "aquamarine")
;;        (font-lock-preproc-face         "Plum1")      ; used by my c-mode
;;        (font-lock-define-face          "Green3")     ; ditto
;;        (font-lock-alarm-face           "red")        ; ditto
;;        (font-lock-faded-face           "grey55")     ; ditto
;;        (font-lock-TRC-face             "RosyBrown1") ; ditto
;;        ; Message colors 
;;        (font-lock-msg-subject-face     "RoyalBlue1")
;;        (font-lock-msg-from-face        "Green")
;;        (font-lock-msg-separator-face   "Black" "LightBlue")
;;        (font-lock-msg-header-face      "IndianRed1")
;;        (font-lock-msg-quote-face       "Pink")

