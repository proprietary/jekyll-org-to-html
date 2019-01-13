require_relative '../lib/jekyll_org_to_html.rb'
require 'test/unit'

class TestOrgToHTML < Test::Unit::TestCase

  include Jekyll
  
  def test_html_generation
    basic_example = <<END_ORG
* top level headline
** tier 2 headline
section text
END_ORG
    signature_for_html = '<?xml version="1.0" encoding="utf-8"?>'
    html_output = Jekyll::OrgModeConverter.new.convert basic_example
    assert_equal html_output.lines[0].chomp!, signature_for_html
  end
  
end
