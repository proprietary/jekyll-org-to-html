# jekyll-org-to-html

Jekyll converter for org-mode (Emacs) files. Unlike other org-mode converters for Jekyll, this invokes Emacs directly and uses Emacs's mature implementation of org-mode to convert your org-mode files to HTML the fly.

Yes, this is much less efficient than a standalone implementation of an org-mode parser and HTML exporter; a new Emacs process is created for every org-mode file being converted. But the idea of a static site generator is to build your website once on your local machine, like compiling an executable binary for distribution. If building the website takes 5 seconds longer, that doesn't really matter. I'll take 5 seconds of waiting in exchange for a lack of weird bugs.

# Dependencies

Emacs (≥v25 preferably) must be installed and visible on your PATH.

# Installation

    $ gem install jekyll-org-to-html

Add `gem "jekyll-org-to-html"` to your Gemfile.

Add to `_config.yml` in the root directory of your Jekyll site:

```yaml
plugins:
  - jekyll-org-to-html
```

Any posts/pages you create with the .org extension should generate as HTML. You can set org-mode options as usual with the `#+OPTIONS` directive at the top of each org-mode file (below the front matter). Example:

	---
	layout: default
	---
	
	#+OPTIONS: toc:t
	* my headline
	my section
	* my second headline
	** my subheadline
	my second section


Everything you can do by writing an org-mode file and exporting it as HTML in Emacs can be done here because it uses Emacs itself to do the conversion.


