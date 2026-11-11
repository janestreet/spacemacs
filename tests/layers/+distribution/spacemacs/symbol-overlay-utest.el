;;; symbol-overlay-utest.el --- Symbol overlay tests -*- lexical-binding: nil; -*-
;;
;; Copyright (c) 2012-2025 Sylvain Benner & Contributors
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

(require 'cl-lib)

(defun spacemacs-test--symbol-overlay-doc (scope)
  (cl-letf (((symbol-function 'symbol-overlay-get-symbol)
             (lambda () 'example))
            ((symbol-function 'symbol-overlay-assoc)
             (lambda (_symbol) (list 'example scope 'red)))
            ((symbol-function 'symbol-overlay-get-list)
             (lambda (direction _symbol)
               (if (< direction 0)
                   '(before)
                 '(current next)))))
    (substring-no-properties (spacemacs//symbol-overlay-doc))))

(ert-deftest test-spacemacs-symbol-overlay-doc--buffer ()
  (should
   (equal " Buffer [2/3] "
          (spacemacs-test--symbol-overlay-doc nil))))

(ert-deftest test-spacemacs-symbol-overlay-doc--scope ()
  (should
   (equal " Scope [2/3] "
          (spacemacs-test--symbol-overlay-doc t))))

(provide 'symbol-overlay-utest)
