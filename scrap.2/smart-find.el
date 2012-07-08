;;; smart-find.el --- A smarter find-file routine.

;;; Author: Chris Thomas <cjthomas@objectspace.com>
;;; Created: 6/23/94
;;; Last Updated: 8/31/95
;;; Version: 1.04
;;; Keywords: find-file, wildcard

;;; Copyright (C) 1994, 1995 Chris Thomas <cjthomas@objectspace.com>
;;;
;;; Verbatim copies of this file may be freely redistributed.
;;;
;;; Modified versions of this file may be redistributed provided that this
;;; notice remains unchanged, the file contains prominent notice of
;;; author and time of modifications, and redistribution of the file
;;; is not further restricted in any way.
;;;
;;; This file is distributed `as is', without warranties of any kind.

;;; Purpose:
;;; ========
;;; smart-find-file has all of the functionality of regular find-file, plus
;;; the ability to load multiple files that match a wildcard pattern.
;;; Patterns may contain multiple wildcards.
;;;
;;; For example, Os*.cpp would load all of the files beginning with "Os", and
;;; ending with .cpp.

;;; Installation:
;;; =============
;;; To your .emacs file,  add: 
;;;    (load "smart-find")
;;;    (global-set-key "\C-x\C-f" 'smart-find-file)

;;; Platforms:
;;; ==========
;;; smart-find seems to function correctly with:
;;;   XEmacs Lucid 19.12 
;;;   GNU Emacs 19.25
;;;   GNU Emacs 18.59

(provide 'smart-file)

; An internal routine to fix regexp patterns.
(defun smart-find-fix-regexp (regexp)
  (if (not (= 0 (length regexp)))
      (progn
	; expand *s
	(setq start 0)
	(while (setq start (string-match "\*" regexp start))
	  (setq regexp 
		(concat 
		 (substring regexp 0 start) 
		 "[^ ]*" 
		 (substring regexp (+ 1 start) (length regexp))))
	  (setq start (+ start 5)))
	
	; expand .s
	(setq start 0)
	(while (setq start (string-match "[.]" regexp start))
	  (setq regexp (concat (substring regexp 0 start) "\\." (substring regexp (+ 1 start) (length regexp))))
	  (setq start (+ start 2)))
	
         ; return string
	(concat "^" regexp "$"))

    ; else return nil
    nil))




(defun smart-find-file ()
  "A smarter find-file."
  (interactive)
  (setq smart-regexp (read-file-name "Smart find file: " default-directory))
  (setq smart-find-directory (file-name-directory smart-regexp))
  (setq smart-find-regexp (smart-find-fix-regexp (file-name-nondirectory smart-regexp)))
  
  (setq smart-file-list (directory-files smart-find-directory t smart-find-regexp))

  (setq smart-file-count 0)
  (if (and smart-find-regexp (setq smart-find-first-file (car smart-file-list)))
      (progn
	(while (car smart-file-list)
	  (switch-to-buffer (find-file-noselect (car smart-file-list)))
	  (setq smart-file-list (cdr smart-file-list))
	  (setq smart-file-count (+ smart-file-count 1)))
	(switch-to-buffer (find-file-noselect smart-find-first-file))
	(message (concat (int-to-string smart-file-count) " files loaded.")))
    
    ; else
    (if (string-match "\*" smart-regexp)
	(progn (beep) (message "Failed to find files matching pattern."))
       ; else
      (setq message "first")
      (switch-to-buffer (find-file-noselect smart-regexp)))))

;;; end of smart-find.el


