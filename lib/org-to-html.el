(package-initialize)

(require 'org)
(require 'cl)

(defun org->html-impl (org-text)
  (with-temp-buffer
    (insert org-text)
    (org-html-export-as-html nil nil nil t '(:with-toc nil :with-latex t :with-smart-quotes t :with-author nil :with-date nil :with-footnotes t :with-special-strings t :with-tables t))
    (set-buffer
     (cl-find-if #'(lambda (b) (equal "*Org HTML Export*" (buffer-name b)))
                 (buffer-list)))
    (substring-no-properties (buffer-string))))

(defun org->html-temp-file (org-text)
  (with-temp-file "/tmp/org-to-html"
    (insert (org->html-impl org-text))))

(defun stdout (s)
  (append-to-file
   s
   nil
   "/dev/stdout"))

(defun org->html-1 (org-text)
  (stdout (org->html-impl org-text))
  (save-buffers-kill-terminal))

(defun org->html-2 (org-text)
  (message (org->html-impl org-text)))
