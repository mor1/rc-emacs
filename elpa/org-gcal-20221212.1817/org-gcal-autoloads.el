;;; org-gcal-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "oauth2-auto" "oauth2-auto.el" (0 0 0 0))
;;; Generated autoloads from oauth2-auto.el

(autoload 'oauth2-auto-plist-sync "oauth2-auto" "\
Synchronously call ‘oauth2-auto-plist’ and return result.
For USERNAME and PROVIDER, see.

\(fn USERNAME PROVIDER)" nil nil)

(autoload 'oauth2-auto-access-token-sync "oauth2-auto" "\
Synchronously call ‘oauth2-auto-access-token’ and return result.
For USERNAME and PROVIDER, see.

\(fn USERNAME PROVIDER)" nil nil)

(register-definition-prefixes "oauth2-auto" '("oauth2-auto-"))

;;;***

;;;### (autoloads nil "org-gcal" "org-gcal.el" (0 0 0 0))
;;; Generated autoloads from org-gcal.el

(autoload 'org-gcal-sync "org-gcal" "\
Import events from calendars.
Export the ones to the calendar if unless
SKIP-EXPORT.  Set SILENT to non-nil to inhibit notifications.

\(fn &optional SKIP-EXPORT SILENT)" t nil)

(autoload 'org-gcal-fetch "org-gcal" "\
Fetch event data from google calendar." t nil)

(autoload 'org-gcal-sync-buffer "org-gcal" "\
Sync entries with Calendar events in currently-visible portion of buffer.

Updates events on the server unless SKIP-EXPORT is set. In this case, events
modified on the server will overwrite entries in the buffer.
Set SILENT to non-nil to inhibit notifications.
Set FILTER-DATE to only update events scheduled for later than
‘org-gcal-up-days' and earlier than ‘org-gcal-down-days'.
Set FILTER-MAANGED to only update events with ‘org-gcal-managed-property’ set
to “org”.

\(fn &optional SKIP-EXPORT SILENT FILTER-DATE FILTER-MANAGED)" t nil)

(autoload 'org-gcal-fetch-buffer "org-gcal" "\
Fetch changes to events in the currently-visible portion of the buffer

Unlike ‘org-gcal-sync-buffer’, this will not push any changes to Google
Calendar. For SILENT and FILTER-DATE see ‘org-gcal-sync-buffer’.

\(fn &optional SILENT FILTER-DATE)" t nil)

(autoload 'org-gcal-toggle-debug "org-gcal" "\
Toggle debugging flags for ‘org-gcal'." t nil)

(autoload 'org-gcal-post-at-point "org-gcal" "\
Post entry at point to current calendar.

This overwrites the event on the server with the data from the entry, except if
the ‘org-gcal-etag-property’ is present and is out of sync with the server, in
which case the entry is overwritten with data from the server instead.

If SKIP-IMPORT is not nil, don’t overwrite the entry with data from the server.
If SKIP-EXPORT is not nil, don’t overwrite the event on the server.
For valid values of EXISTING-MODE see
‘org-gcal-managed-post-at-point-update-existing'.

\(fn &optional SKIP-IMPORT SKIP-EXPORT EXISTING-MODE)" t nil)

(autoload 'org-gcal-delete-at-point "org-gcal" "\
Delete entry at point to current calendar.

If called with prefix or with CLEAR-GCAL-INFO non-nil, will clear calendar info
from the entry even if deleting the event from the server fails.  Use this to
delete calendar info from events on calendars you no longer have access to.

\(fn &optional CLEAR-GCAL-INFO)" t nil)

(autoload 'org-gcal-sync-tokens-clear "org-gcal" "\
Clear all Calendar API sync tokens.

  Use this to force retrieving all events in ‘org-gcal-sync’ or
  ‘org-gcal-fetch’." t nil)

(register-definition-prefixes "org-gcal" '("org-gcal-"))

;;;***

;;;### (autoloads nil "org-generic-id" "org-generic-id.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from org-generic-id.el

(autoload 'org-generic-id-get "org-generic-id" "\
Get the ID-PROP property of the entry at point-or-marker POM.
If POM is nil, refer to the entry at point.
If the entry does not have an ID, the function returns nil.
In any case, the ID of the entry is returned.

\(fn &optional ID-PROP POM)" nil nil)

(autoload 'org-generic-id-find "org-generic-id" "\
Return the location of the entry with property ID-PROP, value ID.
The return value is a cons cell (file-name . position), or nil
if there is no entry with that ID.
With optional argument MARKERP, return the position as a new marker.

Normally, if an entry with ID is not found, this function will run
‘org-generic-id-update-id-locations' in order to pick up any updates to the
files, and then search again, before concluding an ID can’t be found. If
CACHED is passed, that function will not be run.

Normally the ID will be searched for in the current buffer before updating ID
locations. This behavior can be disabled with NO-FALLBACK.

\(fn ID-PROP ID &optional MARKERP CACHED NO-FALLBACK)" nil nil)

(autoload 'org-generic-id-update-id-locations "org-generic-id" "\
Scan relevant files for IDs.
Store the relation between files and corresponding IDs.
This will scan all agenda files, all associated archives, and all
files currently mentioned in `org-generic-id-locations'.
When FILES is given, scan also these files.

\(fn ID-PROP &optional FILES SILENT)" t nil)

(autoload 'org-generic-id-locations-load "org-generic-id" "\
Read the data from `org-generic-id-locations-file'." nil nil)

(autoload 'org-generic-id-add-location "org-generic-id" "\
Add the ID with location FILE to the database of ID locations.

\(fn ID-PROP ID FILE)" nil nil)

(autoload 'org-generic-id-find-id-file "org-generic-id" "\
Query the id database for the file in which this ID is located.

If NO-FALLBACK is set, don’t fall back to current buffer if not found in
‘org-generic-id-locations’.

\(fn ID-PROP ID &optional NO-FALLBACK)" nil nil)

(register-definition-prefixes "org-generic-id" '("org-generic-id-"))

;;;***

;;;### (autoloads nil nil ("org-gcal-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-gcal-autoloads.el ends here
