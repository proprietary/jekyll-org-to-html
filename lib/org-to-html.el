(package-initialize)

(require 'org)
(require 'cl)

(setq org-html-postamble nil)

(defun org->html-impl (org-text)
  (with-temp-buffer
    (insert org-text)
    (org-html-export-as-html nil nil nil nil '(:with-toc nil :with-latex t :with-smart-quotes t :with-author nil :with-date nil :with-footnotes t :with-special-strings t :with-tables t))
    (set-buffer
     (cl-find-if #'(lambda (b) (equal "*Org HTML Export*" (buffer-name b)))
                 (buffer-list)))
    (substring-no-properties (buffer-string))))

(defun org->html-temp-file (org-text)
  (with-temp-file "/tmp/org-to-html"
    (insert (org->html-impl org-text))))

(defun org->html (org-file)
  (with-temp-buffer
    (insert-file-contents org-file)
    (org->html-temp-file (buffer-string))))

(defun stdout (s)
  (append-to-file
   s
   nil
   "/dev/stdout"))

(defun org->html-1 (org-text)
  (stdout (org->html-impl org-text))
  (save-buffers-kill-terminal))

(defun org->html-2 (org-text)
  (message "%s" (org->html-impl org-text)))

