;From: Kai Grossjohann <grossjohann@ls6.cs.uni-dortmund.de>
;Subject: flobl -- frame-local buffer list
;Newsgroups: gnu.emacs.sources
;Cc: Ulrich Pfeifer <pfeifer@ls6>, Michael.Huehne@Germany.EU.net,
;    Norbert Goevert <goevert@bib>
;Date: 20 Apr 1997 00:29:17 +0200
;Organization: University of Dortmund, Germany
;Reply-To: Kai Grossjohann <grossjohann@ls6.cs.uni-dortmund.de>
;Path: lyra.csx.cam.ac.uk!nntpfeed.doc.ic.ac.uk!sunsite.doc.ic.ac.uk!netcom.net.uk!data.ramona.vix.com!sonysjc!su-news-hub1.bbnplanet.com!cam-news-hub1.bbnplanet.com!news.bbnplanet.com!news.maxwell.syr.edu!EU.net!main.Germany.EU.net!Dortmund.Germany.EU.net!Informatik.Uni-Dortmund.DE!news
;Lines: 141
;Sender: grossjoh@naunet
;Message-ID: <vafsp0mzlxe.fsf@ls6.cs.uni-dortmund.de>
;NNTP-Posting-Host: naunet.informatik.uni-dortmund.de
;X-Newsreader: Gnus v5.4.45/Emacs 19.34;
;
;
;If you work with several frames and do not like the behavior of the
;buffer list (or buffer menu), this might be for you.;;
;
;I didn't like the way there was only one buffer list, and
;switch-to-buffer operations in one frame moved that buffer to the top
;of the buffer list for all frames.
;
;For example, if I have two frames, one for C programming and one for
;Gnus, and if I switch from the C programming frame to the Gnus frame
;to do some news and mail reading, and if I then come back to the C
;programming frame, I will find the *Group* and *Article* and *Summary*
;buffers from Gnus near the top of the buffer list rather than the C
;buffers I had been visiting when I left the frame.
;
;This little package, flobl.el, corrects this problem (partly).  It
;doesn't change the behavior of other-buffer, so C-x b still offers
;strange default buffers.;
;
;Hope you like it.  Any comments appreciated.  (Especially ideas on
;;what to do about the other-buffer function.)
;
;kai
;-- 
;because I couldn't think of a good beginning.;;
;
;
;; flobl.el -- frame-local buffer list

;; Copyright (C) 1997 Kai Grossjohann
;;
;; Author: Kai Grossjohann <grossjohann@ls6.informatik.uni-dortmund.de>
;; Maintainer: Kai Grossjohann <grossjohann@ls6.informatik.uni-dortmund.de>
;; Created: 19 April 1997
;; Version: 1.0
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; A copy of the GNU General Public License can be obtained from the
;; Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
;; USA.

;; LCD Archive Entry: No archive entry.

;;; Installation:
;;
;; Put the file flobl.el in a directory in your load-path.  Byte
;; compile it.  Put the following in your .emacs (or site-start.el or
;; default.el):
;;
;;              (require 'flobl)
;;
;; It does not make sense to autoload this file.

;;; Commentary:
;;
;; When working with several frames, I was always annoyed that
;; switch-to-buffer commands from frame A interfered with the ordering
;; of the buffers when doing C-x C-b in frame B.  To see this, start
;; Emacs, then create a buffer (C-x b aaa RET).  Then, create a new
;; frame and create two new buffers from the second frame (C-x b bbb
;; RET, then C-x b ccc RET).  Now, go back to the first frame and do
;; C-x C-b.  I wanted Emacs to show the *scratch* buffer and aaa as
;; the top two buffers, but the buffers bbb and ccc get in between.
;;
;; This little package solves this problem.

;;; Bugs, Todo:
;;
;; The behavior of the other-buffer function isn't changed.
;; Therefore, C-x b (switch-to-buffer) still has a strange default
;; buffer.  So far, it works with C-x C-b (list-buffers) only (and
;; with derived commands, such as electric-buffer-list).

(defvar flobl-time-tick 0
  "Incremented by 1 for each switch buffer operation.")

(defvar flobl-buffer-order nil
  "Contains information about recently visited buffers for each frame.")

(defvar flobl-last-frame nil
  "Info about last frame the user was in.")

(defvar flobl-last-buffer nil
  "Info about last buffer the user was in.")

(defun flobl-buffer-order-get-frame (fram)
  "Returns the prio information of buffers for FRAM."
  (plist-get flobl-buffer-order fram))

(defun flobl-buffer-order-get-buffer (fram buf)
  "Returns a number indicating how recently BUF has been visited in FRAM."
  (if (not (framep fram)) (error "%s must be a frame"))
  (if (not (bufferp buf)) (error "%s must be a buffer"))
  (or (plist-get (flobl-buffer-order-get-frame fram) buf) 0))

(defun flobl-buffer-order-update (fram buf)
  "Sets the prio information of BUF in FRAM to PRIO."
  (if (not (framep fram)) (error "%s must be a frame"))
  (if (not (bufferp buf)) (error "%s must be a buffer"))
  (let ((forder (flobl-buffer-order-get-frame fram)))
    (setq forder (plist-put forder buf flobl-time-tick))
    (setq flobl-time-tick (1+ flobl-time-tick))
    (setq flobl-buffer-order
          (plist-put flobl-buffer-order fram forder))))

(defun flobl-post-command-hook ()
  "Runs after every command to update buffer priority information."
  (let ((new-buf (current-buffer))
        (new-fram (selected-frame)))
    (if (and (eq flobl-last-frame new-fram)
             (not (eq flobl-last-buffer new-buf)))
        (flobl-buffer-order-update new-fram new-buf))
    (setq flobl-last-frame new-fram)
    (setq flobl-last-buffer new-buf)))

(add-hook 'post-command-hook 'flobl-post-command-hook)

(defun flobl-cmp-buffers (buf1 buf2)
  "Compares two buffers according to `flobl-buffer-order'."
  (let ((p1 (flobl-buffer-order-get-buffer (selected-frame) buf1))
        (p2 (flobl-buffer-order-get-buffer (selected-frame) buf2)))
    (< p2 p1)))

(defadvice buffer-list (after frame-local-buffer-lists first activate)
  "switch-to-buffer commands in other frames don't affect order of buffers here."
  (setq ad-return-value
        (sort (copy-sequence ad-return-value) 'flobl-cmp-buffers)))

(provide 'flobl)

;; flobl.el ends here
