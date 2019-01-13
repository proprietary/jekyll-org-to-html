require 'jekyll'

$DEBUG = false

$ELISP = <<END
(package-initialize)

(require 'org)
(require 'cl)

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
      # script = IO.read("/home/zds/devel/emacs/org-to-html/org-to-html.elisp").chomp
      escaped_input = content.dump[1..-2]

      elisp = if $DEBUG
                IO.read('./org-to-html.el').dump[1..-2] # escaped
              else
                $ELISP.dump[1..-2]
              end
      # Run our elisp script and receive any errors from stdout
      out = `emacs --batch --eval='#{elisp} (org->html-temp-file "#{escaped_input}")' 2>&1`
      # 2>&1 means redirect stderr to stdout
      # Emacs in `--batch` mode sends output to stderr instead of stdout
      puts out
      raise "Emacs rejected your org-mode file: #{out}" unless
        $?.exitstatus.zero?

      # The elisp script saves the output in this named temp file
      # Warning: possible race condition if Jekyll ever parallelizes conversion

      IO.new(IO.sysopen("/tmp/org-to-html")).read.chomp!
    end
  end
end
