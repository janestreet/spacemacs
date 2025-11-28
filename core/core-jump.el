;;; core-jump.el --- Spacemacs Core File -*- lexical-binding: t -*-
;;
;; Copyright (c) 2012-2025 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


(defvar spacemacs-default-jump-handlers '()
  "List of jump handlers available in every mode.")

(defvar-local spacemacs-jump-handlers '()
  "List of jump handlers local to this buffer.

Jump handlers in this list has the highest priority. A jump
handler jump-handler can be registered by making this call
from a mode hook:

\(add-to-list 'spacemacs-jump-handlers 'jump-handler\)

Handler in this list is called first so only dynamic handlers like
`lsp' should use this one. Conventional jump handlers should use
`spacemacs-jump-handlers-MODE' instead.")

(defmacro spacemacs|define-jump-handlers (mode &rest handlers)
  "Defines jump handlers for the given MODE.

This defines a variable `spacemacs-jump-handlers-MODE' to which
handlers can be added. MODE must be a major mode."
  (let ((mode-hook (intern (format "%S-hook" mode)))
        (handlers-list (intern (format "spacemacs-jump-handlers-%S" mode))))
    `(progn
       (defvar ,handlers-list ',handlers
         ,(format (concat "List of mode-specific jump handlers for %S. "
                          "These take priority over those in "
                          "`spacemacs-default-jump-handlers'.")
                  mode))
       (with-eval-after-load 'bind-map
         (spacemacs/set-leader-keys-for-major-mode ',mode
           "gg" 'spacemacs/jump-to-definition
           "gG" 'spacemacs/jump-to-definition-other-window)))))

(defun spacemacs//get-jump-handlers ()
  "Combine all jump handlers into a list.

They are in order: `spacemacs-jump-handlers',
`spacemacs-jump-handlers-MAJOR-MODE',
`spacemacs-default-jump-handlers'."
  (let ((handlers-major-mode-list (intern (format "spacemacs-jump-handlers-%S"
                                                  major-mode))))
    (append spacemacs-jump-handlers
            (if (boundp handlers-major-mode-list)
                (symbol-value handlers-major-mode-list)
              '())
            spacemacs-default-jump-handlers)))

(defun spacemacs/jump-to-definition ()
  "Jump to definition around point using the best tool for this action."
  (interactive)
  (catch 'done
    (dolist (-handler (spacemacs//get-jump-handlers))
      ;; TODO: Some jump handlers specify an :async keyword if they jump
      ;; asynchronously (e.g., the command finishes executing before the jump
      ;; may happen).  `spacemacs/jump-to-definition' used to handle
      ;; asynchronous jump handlers differently, but now it handles async and
      ;; sync ones uniformly.
      (let ((handler (if (listp -handler) (car -handler) -handler)))
        (condition-case nil
            (progn (call-interactively handler)
                   (throw 'done t))
          (error nil))))
    (error "No jump handler was able to find this symbol")))

(defun spacemacs/jump-to-definition-other-window ()
  "Jump to definition around point in other window."
  (interactive)
  (let ((pos (point)))
    ;; since `spacemacs/jump-to-definition' can be asynchronous we cannot use
    ;; `save-excursion' here, so we have to bear with the jumpy behavior.
    ;;
    ;; TODO: Can we replace asynchronous jump handlers with synchronous ones?
    ;; (In theory one could always wrap async ones).  That would fix the issue
    ;; where `spacemacs/jump-to-definition-other-window' may open another window
    ;; but then the jump handler might fail.  (It should only open another
    ;; window if it can successfully determine where to jump to).
    (switch-to-buffer-other-window (current-buffer))
    (goto-char pos)
    (spacemacs/jump-to-definition)))

;; Set the `:jump' property manually instead of just using `evil-define-motion'
;; in an `eval-after-load' macro invocation because doing that prevents
;; `describe-function' from correctly finding the source.
;;
;; See discussion on https://github.com/syl20bnr/spacemacs/pull/6771
(with-eval-after-load 'evil
  (evil-set-command-property 'spacemacs/jump-to-definition :jump t))

(spacemacs|eval-until-emacs-min-version "29.1"
  (unless (fboundp 'xref-go-back)
    (defalias 'xref-pop-marker-stack 'xref-go-back)))

(provide 'core-jump)
