require './lib/inports'
Bundler.require(:test)

class TestLinkHelpers < MiniTest::Unit::TestCase
  def test_parse_returns_link_helpers_object
    l = LinkHelpers.parse('', '')
    assert_kind_of LinkHelpers, l
  end


  def test_link_helpers_object_has_accessors
    l = LinkHelpers.parse('abc#what', 'abc')
    assert LinkHelpers, l.path
    assert LinkHelpers, l.key
    assert LinkHelpers, l.anchor
  end


  def test_link_helpers_parser_absolutes_links
    l = LinkHelpers.parse('abc.htm', '/123')
    assert_equal '/abc.htm', l.path

    l = LinkHelpers.parse('abc.htm', '/123/456')
    assert_equal '/123/abc.htm', l.path

    l = LinkHelpers.parse('/123/abc.htm', '/123/456')
    assert_equal '/123/abc.htm', l.path
  end


  def test_link_helpers_parser_stores_anchors
    l = LinkHelpers.parse('abc.htm#abc', '/123')
    assert_equal '#abc', l.anchor

    l = LinkHelpers.parse('/123/abc.htm#abc', '/123')
    assert_equal '#abc', l.anchor

    l = LinkHelpers.parse('abc.htm', '/123')
    refute l.anchor
  end


  def test_link_helpers_parser_strips_anchors_from_path_and_key
    CONFIG['directories']['input'] = './input'

    l = LinkHelpers.parse('abc.htm#abc', '/123')
    assert_equal '/abc.htm', l.path

    l = LinkHelpers.parse('/123/abc.htm#abc', '/123')
    assert_equal './input/123/abc.htm', l.key
  end


  def test_link_helpers_parser_makes_key
    CONFIG['directories']['input'] = './input'

    l = LinkHelpers.parse('abc.htm', '/123')
    assert_equal './input/abc.htm', l.key

    l = LinkHelpers.parse('abc.htm', '/123/456')
    assert_equal './input/123/abc.htm', l.key

    l = LinkHelpers.parse('/123/abc.htm', '/123/456')
    assert_equal './input/123/abc.htm', l.key
  end


  def test_link_helpers_parser_disregards_index
    CONFIG['directories']['input'] = './input'

    l = LinkHelpers.parse('index.htm', '/123')
    assert_equal './input', l.key

    l = LinkHelpers.parse('index.html', '/123/456')
    assert_equal './input/123', l.key

    l = LinkHelpers.parse('/123/index.htm', '/123/456')
    assert_equal './input/123', l.key
  end


  def test_special_resolvers_return_nil_for_regular_links
    refute LinkHelpers.special_resolvers('/some/url/thing.htm')
    refute LinkHelpers.special_resolvers('some/url/thing.html')
    refute LinkHelpers.special_resolvers('somewhere/here')
  end


  def test_special_resolvers_return_ids_for_glossary_links
    id = LinkHelpers.special_resolvers('/GlossaryItem.htm?GID=227')
    assert_equal id, CONFIG['ids']['glossary']

    id = LinkHelpers.special_resolvers('/glossaryitem.htm?GID=276')
    assert_equal id, CONFIG['ids']['glossary']

    id = LinkHelpers.special_resolvers('/glossary.htm?GID=276')
    assert_equal id, CONFIG['ids']['glossary']
  end
end
