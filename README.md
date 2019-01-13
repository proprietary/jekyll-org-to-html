# jekyll-org-to-html

Jekyll converter for org-mode (Emacs) files. Unlike other org-mode converters for Jekyll, this invokes Emacs directly and uses Emacs's mature implementation of org-mode to convert your org-mode files to HTML the fly.

Yes, this is much less efficient than a standalone implementation of an org-mode parser and HTML exporter; a new Emacs process is created for every org-mode file being converted. But the idea of a static site generator is to build your website once on your local machine, like compiling an executable binary for distribution. If building the website takes 5 seconds longer, that doesn't really matter. I'll take 5 seconds of waiting in exchange for a lack of weird bugs.

