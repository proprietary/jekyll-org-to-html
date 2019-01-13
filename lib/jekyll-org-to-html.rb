require 'jekyll'
require 'tempfile'

ELISP = <<END
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
END

module Jekyll
  class OrgModeConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.org$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      elisp_script = Tempfile.new 'org-to-html-elisp'
      elisp_script.write ELISP
      elisp_script.rewind

      content_as_file = Tempfile.new
      content_as_file.write content
      content_as_file.rewind

      # Run our elisp script and receive any errors from stdout      
      out = `emacs --batch --load '#{elisp_script.path}' --eval '(org->html \"#{content_as_file.path}\")' 2>&1`
      # 2>&1 means redirect stderr to stdout
      # Emacs in `--batch` mode sends output to stderr instead of stdout
      raise "Emacs rejected your org-mode file: #{out}" unless
        $?.exitstatus.zero?

      # Remove the temp files
      elisp_script.unlink
      content_as_file.unlink

      # The elisp script saves the output in this named temp file
      # Warning: possible race condition if Jekyll ever parallelizes conversion
      # Don't change the name of this temp file without also changing
      # it in the elisp code above.
      File.open("/tmp/org-to-html", "r").read
    end
  end
end
