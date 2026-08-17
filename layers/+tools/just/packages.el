;;; packages.el --- Just layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2026 Sylvain Benner & Contributors
;;
;; Author: Dietrich Daroch <Dietrich@Daroch.me>
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

;; Briefly, each package to be installed or configured by this layer should be
;; added to `just-packages'.
(defconst just-packages
  '(
    ;; https://github.com/psibi/justl.el
    justl
    ;; https://github.com/leon-barrett/just-ts-mode.el
    just-ts-mode
    ))

;; Then, for each package PACKAGE:

;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `just/init-PACKAGE' to load and initialize the package.
(defun just/init-justl ()
  "Initialization for justl (not referenced by another Spacemacs layer)"
  (use-package justl
    :defer t
    :init
    (spacemacs/declare-prefix "pJ" "Just")
    (spacemacs/set-leader-keys
      "pj" 'justl-exec-default-recipe
      "pJj" 'justl-exec-default-recipe
      "pJJ" 'justl-exec-recipe-in-dir
      "pJl" 'justl)))
(defun just/init-just-ts-mode ()
  "Initialization for just-ts-mode (not referenced by another Spacemacs layer)"
  (use-package just-ts-mode
    :config
    ))

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `just/pre-init-PACKAGE' and/or
;;   `just/post-init-PACKAGE' to customize the package as it is loaded.
