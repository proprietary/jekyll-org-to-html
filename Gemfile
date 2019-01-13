source 'https://rubygems.org'

gemspec

if ENV["JEKYLL_VERSION"]
  if ENV["JEKYLL_VERSION"].eql?("tip")
    gem "jekyll", github: "jekyll/jekyll", branch: ENV["JEKYLL_BRANCH"]
  else
    gem "jekyll", "~> #{ENV["JEKYLL_VERSION"]}"
  end
else
  gem "jekyll", ">= 2.0"
end
