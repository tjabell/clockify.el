;;; clockify.el --- Start and stop task inside Emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Marco Dalla Stella

;; Author: Marco Dalla Stella <marco@dallastella.name>
;; Keywords: calendar, tools
;; Package-Requires: ((emacs "25") (projectile "0") (request "0") (json "0"))
;; Version 0.0.1

;;; Commentary:

;;; Code:

(require 'json)
(require 'request)
(require 'cl)

;;; User-Configurable Variables
(defgroup clockify nil
  "Manage Clockify tasks from Emacs"
  :tag "Clockify"
  :group 'calendar)

(defcustom clockify-auth-token nil
  "User authorization token."
  :type 'string)

;;; Constants
(defconst clockify-api-url "https://api.clockify.me/api/v1")

;;; Support Functions
(defun clockify--user-endpoint ()
  "Clockify user endpoint"
  (concat clockify-api-url "/user"))

;;; Functions

(defun clockify--query (method endpoint &optional data)
  "Send queries to Clockify APIs.
METHOD is the HTTP method to user
ENDPOINT id the API to hit
DATA is the optional body of the request"
  (let ((response (request-response-data
		   (request endpoint
			    :type method
			    :headers (cons `("X-Api-Key" . ,clockify-auth-token)
					   '(("Content-Type" . "application/json")))

			    :sync t
			    :parser 'json-read
			    :error (function*
				    (lambda (&key error-thrown &allow-other-keys&rest _)
				      (message "Got error: %S" error-thrown)))))))
    response))

(defun clockify-user-info ()
  "Retrieve user information."
  (clockify--query "GET"
		   (clockify--user-endpoint)))

(provide 'clockify)
;;; clockify.el ends here
