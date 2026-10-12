;;; funcs.el --- compleseus Layer functions File for Spacemacs -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2012-2025 Sylvain Benner & Contributors
;;
;; Author: Thanh Vuong <thanhvg@gmail.com>
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


(defun compleseus//persp-contain-buffer-p (buf)
  "Return non-nil if BUF is part of the current perspective.

If persp-mode is not currently used, this function always returns
non-nil."
  (if (fboundp 'persp-contain-buffer-p)
      (persp-contain-buffer-p buf)
    t))


(defun spacemacs/compleseus-switch-to-buffer ()
  "`consult-buffer' with buffers provided by persp."
  (interactive)
  (consult-buffer (if (configuration-layer/package-used-p 'persp-mode)
                      compleseus-switch-to-buffer-sources
                    consult-buffer-sources)))

(defun spacemacs/initial-search-input (&optional force-input)
  "Get initial input from region for consult search functions.

If region is not active and FORCE-INPUT is non-nil, return the symbol at point.
If FORCE-INPUT is nil or there is no symbol at point,
return the empty string."
  (if (use-region-p)
      (buffer-substring-no-properties
       (region-beginning) (region-end))
    (or (and force-input (thing-at-point 'symbol t))
        "")))

(defun spacemacs/compleseus-search (force-initial-input initial-directory)
  (let* ((initial-input (regexp-quote
                         (spacemacs/initial-search-input force-initial-input)))
         (default-directory
          (or initial-directory (read-directory-name "Start from directory: "))))
    (consult-ripgrep default-directory initial-input)))

(defun spacemacs/consult-line ()
  (interactive)
  (consult-line
   (spacemacs/initial-search-input)))

(defun spacemacs/consult-line-symbol ()
  (interactive)
  (consult-line
   (spacemacs/initial-search-input t)))

(defun spacemacs/consult-line-multi (&optional toggle-restrict)
  "Search project buffers using `consult-line-multi'.
If the prefix argument TOGGLE-RESTRICT is non-nil, search all buffers.

If the region is active, it is used as the initial input.

The effect of the prefix argument can be inverted by setting
`compleseus-buffer-search-restrict-project' to nil."
  (interactive "P")
  (unless compleseus-buffer-search-restrict-project
    (setq toggle-restrict (not toggle-restrict)))
  (consult-line-multi toggle-restrict (spacemacs/initial-search-input)))

(defun spacemacs/consult-line-multi-symbol (&optional toggle-restrict)
  "Search project buffers using `consult-line-multi'.
If the prefix argument TOGGLE-RESTRICT is non-nil, search all buffers.

The active region or symbol at point is used as the initial input.

The effect of the prefix argument can be inverted by setting
`compleseus-buffer-search-restrict-project' to nil."
  (interactive "P")
  (unless compleseus-buffer-search-restrict-project
    (setq toggle-restrict (not toggle-restrict)))
  (consult-line-multi toggle-restrict (spacemacs/initial-search-input t)))

(defun spacemacs/embark-consult-line-multi (buffer-names)
  "Embark action to search in any subset of buffers using `consult-line-multi'.
If there is an active region, it is used as the initial input."
  (consult-line-multi
   (list :predicate (lambda (buf) (member (buffer-name buf) buffer-names)))
   (spacemacs/initial-search-input)))

(defun spacemacs/compleseus-search-auto ()
  "Choose folder to search."
  (interactive)
  (spacemacs/compleseus-search nil nil))

(defun spacemacs/compleseus-search-auto-symbol ()
  "Choose folder to search."
  (interactive)
  (spacemacs/compleseus-search t nil))

(defun spacemacs/compleseus-search-dir ()
  "Search current folder."
  (interactive)
  (spacemacs/compleseus-search nil default-directory))

(defun spacemacs/compleseus-search-dir-symbol ()
  "Search current folder."
  (interactive)
  (spacemacs/compleseus-search t default-directory))

(defun spacemacs/compleseus-search-projectile ()
  "Search in current project."
  (interactive)
  (spacemacs/compleseus-search nil (projectile-project-root)))

(defun spacemacs/compleseus-search-projectile-symbol ()
  "Search in current project."
  (interactive)
  (spacemacs/compleseus-search t (projectile-project-root)))

(defun spacemacs/compleseus-search-default ()
  "Search."
  (interactive)
  (spacemacs/compleseus-search-projectile-symbol))

(defun spacemacs/compleseus-search-from (input)
  "Embark action to start ripgrep search from candidate's directory."
  (interactive "s")
  (message "The first input %s." input)
  (let ((dir (if (file-directory-p input)
                 input
               (file-name-directory input))))
    (consult-ripgrep dir)))

(defun spacemacs/compleseus-find-file ()
  "Calls the interactive find-file browser.
This solves the problem: Binding a key to: `find-file' calls: `ido-find-file'"
  (interactive)
  (call-interactively 'find-file))

(defun spacemacs/compleseus-find-file-below ()
  "Find a file anywhere below the directory in the current file-name prompt.

Like ivy's `counsel-file-jump', list all files below the directory
typed so far with fd (or find, if fd is not installed), and filter
them with `completing-read' using the rest of the input as the initial
query.

In the search prompt, \\``' returns to the original prompt with the
search query in place of the file name."
  (interactive)
  (let* ((typed-dir (or (file-name-directory (minibuffer-contents)) ""))
         (input (substitute-in-file-name (minibuffer-contents)))
         (default-directory
          (expand-file-name (or (file-name-directory input) default-directory)))
         (fd (or (executable-find "fdfind" t) (executable-find "fd" t)))
         (files (with-delayed-message
                    (0.5 (format "Listing files below %s..."
                                 (abbreviate-file-name default-directory)))
                  (with-temp-buffer
                    ;; `process-file' runs on the remote host over TRAMP.
                    ;; Discard stderr, so errors don't become candidates.
                    (if fd
                        (process-file fd nil '(t nil) nil "--color=never")
                      (process-file "find" nil '(t nil) nil "." "-mindepth" "1"))
                    (mapcar (lambda (file) (string-remove-prefix "./" file))
                            (split-string (buffer-string) "\n" t)))))
         (completion-category-overrides
          ;; These are files, but unlike `find-file' which completes
          ;; per-component, fall back to `completion-styles'.  (See
          ;; `completion-category-overrides' in packages.el).
          (cons '(file (styles)) completion-category-overrides))
         (table (lambda (string pred action)
                  (if (eq action 'metadata)
                      '(metadata (category . file))
                    (complete-with-action action files string pred))))
         (resume-outer-prompt nil)
         (result
          (minibuffer-with-setup-hook
              (:append (lambda ()
                         (use-local-map
                          (make-composed-keymap
                           (define-keymap
                             ;; `exit-minibuffer' returns the query, skipping
                             ;; the require-match check.
                             "`" (lambda ()
                                   (interactive)
                                   (setq resume-outer-prompt t)
                                   (exit-minibuffer)))
                           (current-local-map)))))
            (completing-read (format "Find below %s: "
                                     (abbreviate-file-name default-directory))
                             table nil t (file-name-nondirectory input)))))
    (delete-minibuffer-contents)
    (insert typed-dir result)
    (unless resume-outer-prompt (exit-minibuffer))))

(defvar-keymap compleseus-file-prompt-map
  :doc "Keymap active in file-name prompts, in addition to `vertico-map'."
  "`" #'spacemacs/compleseus-find-file-below)

(defun compleseus//setup-file-prompt ()
  "Activate `compleseus-file-prompt-map' in file-name prompts."
  ;; `minibuffer-completing-file-name' is non-nil when completing a file name.
  ;;
  ;; A comment in minibuffer.el calls it internal-ish, but keeps it non-obsolete
  ;; for the sake of `rfn-eshadow-setup-minibuffer', and mentions that checking
  ;; `minibuffer-completion-table' against `read-file-name-internal' is
  ;; "probably even worse".  For now, it's the least-bad API to rely on.
  (when minibuffer-completing-file-name
    (use-local-map (make-composed-keymap compleseus-file-prompt-map
                                         (current-local-map)))))

;; persp-mode stuff
(defun spacemacs/compleseus-spacemacs-layout-layouts ()
  (interactive)
  (spacemacs//create-persp-with-home-buffer
   (completing-read "Layouts:" (persp-names))))

;; vertico
(defun spacemacs/embark-select ()
  "Select the current candidate in the vertico buffer
to act on with `embark-act-all', and move to the next candidate."
  (interactive)
  (embark-select)
  (vertico-next))

(defun spacemacs/embark-preview ()
  "Previews candidate in vertico buffer, unless it's a consult command"
  (interactive)
  (unless (bound-and-true-p consult--preview-function)
    (save-selected-window
      (let ((embark-quit-after-action nil))
        (embark-dwim)))))

(defun spacemacs/next-candidate-preview (&optional n)
  "Go forward N candidates and preview"
  (interactive)
  (vertico-next (or n 1))
  (spacemacs/embark-preview))

(defun spacemacs/previous-candidate-preview (&optional n)
  "Go backward N candidates and preview"
  (interactive)
  (vertico-previous (or n 1))
  (spacemacs/embark-preview))

;; which-key integration functions for embark
;; https://github.com/oantolin/embark/wiki/Additional-Configuration#use-which-key-like-a-key-menu-prompt
(defun spacemacs/embark-which-key-indicator ()
  "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
  (lambda (&optional keymap targets prefix)
    (if (null keymap)
        (which-key--hide-popup-ignore-command)
      (which-key--show-keymap
       (if (eq (plist-get (car targets) :type) 'embark-become)
           "Become"
         (format "Act on %s '%s'%s"
                 (plist-get (car targets) :type)
                 (embark--truncate-target (plist-get (car targets) :target))
                 (if (cdr targets) "…" "")))
       (if prefix
           (pcase (lookup-key keymap prefix 'accept-default)
             ((and (pred keymapp) km) km)
             (_ (key-binding prefix 'accept-default)))
         keymap)
       nil nil t (lambda (binding)
                   (not (string-suffix-p "-argument" (cdr binding))))))))

(defun spacemacs/embark-hide-which-key-indicator (fn &rest args)
  "Hide the which-key indicator immediately when using the completing-read prompter."
  (which-key--hide-popup-ignore-command)
  (let ((embark-indicators
         (remq #'spacemacs/embark-which-key-indicator embark-indicators)))
    (apply fn args)))

(defun spacemacs/embark-action-completing-read ()
  "Bypass `embark-act' and execute `embark-keymap-help' directly.

This function mimics the Helm action menu.
Note: this function relies on embark internals and might break upon embark updates.
"
  (interactive)
  (require 'embark)
  (let* ((targets (or (embark--targets) (user-error "No target found")))
         (indicators (mapcar #'funcall embark-indicators))
         (default-done nil))
    (unwind-protect
        (while
            (let* ((target (car targets))
                   (action (embark-completing-read-prompter
                            (let ((embark-default-action-overrides
                                   (if default-done
                                       `((t . ,default-done))
                                     embark-default-action-overrides)))
                              (embark--action-keymap (plist-get target :type)
                                                     (cdr targets)))
                            nil))
                   (default-action (or default-done
                                       (embark--default-action
                                        (plist-get target :type)))))
              ;; if the action is non-repeatable, cleanup indicator now
              (mapc #'funcall indicators)
              (condition-case err
                  (embark--act
                   action
                   (if (and (eq action default-action)
                            (eq action embark--command)
                            (not (memq action embark-multitarget-actions)))
                       (embark--orig-target target)
                     target)
                   (embark--quit-p action))
                (user-error
                 (funcall (if repeat #'message #'user-error)
                          "%s" (cadr err))))))
      (mapc #'funcall indicators))))

(defun spacemacs/minibuffer-default-add-function ()
  "See `minibuffer-default-add-function'"
  (with-selected-window (minibuffer-selected-window)
    (delete-dups
     (delq nil
           (list (thing-at-point 'symbol)
                 (thing-at-point 'list)
                 (thing-at-point-url-at-point))))))

(defun spacemacs/consult-jump-in-buffer ()
  "Jump in buffer with `consult-imenu' or `consult-org-heading' if in org-mode"
  (interactive)
  (call-interactively
   (cond
    ((eq major-mode 'org-mode) 'consult-org-heading)
    (t 'consult-imenu))))

(defun spacemacs/consult-narrow-cycle-backward ()
  "Cycle backward through the narrowing keys."
  (interactive)
  (when-let* ((narrow-keys (plist-get consult--narrow-config :keys)))
    (consult-narrow
     (if consult--narrow
         (let ((idx (seq-position narrow-keys
                                  (assq consult--narrow narrow-keys))))
           (unless (eq idx 0)
             (car (nth (1- idx) narrow-keys))))
       (caar (last narrow-keys))))))

(defun spacemacs/consult-narrow-cycle-forward ()
  "Cycle forward through the narrowing keys."
  (interactive)
  (when-let* ((narrow-keys (plist-get consult--narrow-config :keys)))
    (consult-narrow
     (if consult--narrow
         (let ((idx (seq-position narrow-keys
                                  (assq consult--narrow narrow-keys))))
           (unless (eq idx (1- (length narrow-keys)))
             (car (nth (1+ idx) narrow-keys))))
       (caar narrow-keys)))))

(defun spacemacs/consult-edit ()
  "Export the consult buffer and make the buffer editable right away."
  (interactive)
  (require 'embark)
  (let ((embark-after-export-hook '(spacemacs/grep-change-to-wgrep-mode)))
    (embark-export)))

(defvar compleseus--previous-preview-keys nil
  "variable to store the former value of preview keys or nil if the preview
 has not been toggled on")

(defun spacemacs/consult-toggle-preview ()
  "Toggle auto-preview mode for compleseus buffers"
  (interactive)
  (if (eq compleseus--previous-preview-keys nil)
      (setq compleseus--previous-preview-keys consult-preview-key
            consult-preview-key '(:debounce 0.5 any))
    (setq consult-preview-key compleseus--previous-preview-keys
          compleseus--previous-preview-keys nil)
    )
  )
