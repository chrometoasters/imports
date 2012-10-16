require './lib/inports'
Bundler.require(:test)

class TestIncludeResolver < MiniTest::Unit::TestCase
  include IncludeResolver
  include STFU

  def setup
    CONFIG['directories']['input'] = './test/mocks'
  end


  def test_make_path_absolute_returns_full_paths
    path = make_path_absolute('relative_include.cfm', './test/mocks/somefile.htm')
    assert_equal path, './test/mocks/relative_include.cfm'

    path = make_path_absolute('relative_include.cfm', './test/mocks/things/somefile.htm')
    assert_equal path, './test/mocks/things/relative_include.cfm'

    path = make_path_absolute('/absolute_include.cfm', './test/mocks/somefile.htm')
    assert_equal path, './test/mocks/absolute_include.cfm'

    path = make_path_absolute('/things/absolute_include.cfm', './test/mocks/things/somefile.htm')
    assert_equal path, './test/mocks/things/absolute_include.cfm'
  end


  def test_get_nokogiridoc_from_path_returns_doc_by_default
    doc = get_nokogiridoc_from_path('./test/mocks/has_includes.htm')
    assert_kind_of Nokogiri::HTML::Document, doc
  end


  def test_get_nokogiridoc_from_path_returns_fragment_when_required
    doc = get_nokogiridoc_from_path('./test/mocks/has_includes.htm', '!')
    assert_kind_of Nokogiri::HTML::DocumentFragment, doc
  end


  def test_unresolved_includes_replaced_with_tag
    shh { @str = resolve_includes('./test/mocks/has_includes.htm') }
    assert_match /<include_tag_that_could_not_be_resolved/, @str
  end


  def test_resolved_includes_inserted_in_place_of_cfinclude_element
    shh { @str = resolve_includes('./test/mocks/has_includes.htm') }
    assert_match /footer-links/, @str
  end
end
