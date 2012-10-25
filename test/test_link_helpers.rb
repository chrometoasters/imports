require './lib/inports'
Bundler.require(:test)

class TestLinkHelpers < MiniTest::Unit::TestCase
  def teardown
    $r.kill_keys
  end

  def test_parse_returns_link_helpers_object
    l = LinkHelpers.parse('./', './')
    assert_kind_of LinkHelpers, l
  end


  def test_link_helpers_object_has_accessors
    l = LinkHelpers.parse('abc#what', 'abc/')
    assert LinkHelpers, l.path
    assert LinkHelpers, l.key
    assert LinkHelpers, l.anchor
  end


  def test_link_helpers_parser_absolutes_links
    l = LinkHelpers.parse('abc.htm', '/123/')
    assert_equal '/123/abc.htm', l.path

    l = LinkHelpers.parse('abc.htm', '/123/456/')
    assert_equal '/123/456/abc.htm', l.path

    l = LinkHelpers.parse('/123/abc.htm', '/123/456/')
    assert_equal '/123/abc.htm', l.path

    l = LinkHelpers.parse('123/abc/', '/ABC/')
    assert_equal '/ABC/123/abc/', l.path

    l = LinkHelpers.parse('../absolute_include.cfm', '/things/')
    assert_equal '/absolute_include.cfm', l.path
  end


  def test_link_helpers_parser_stores_anchors
    l = LinkHelpers.parse('abc.htm#abc', '/123/')
    assert_equal '#abc', l.anchor

    l = LinkHelpers.parse('/123/abc.htm#abc', '/123/')
    assert_equal '#abc', l.anchor

    l = LinkHelpers.parse('abc.htm', '/123/')
    refute l.anchor
  end


  def test_link_helpers_parser_strips_anchors_from_path_and_key
    CONFIG['directories']['input'] = './input/'

    l = LinkHelpers.parse('abc.htm#abc', '/123/')
    assert_equal '/123/abc.htm', l.path

    l = LinkHelpers.parse('/123/abc.htm#abc', '/123/')
    assert_equal './input/123/abc.htm', l.key
  end


  def test_link_helpers_parser_makes_key
    CONFIG['directories']['input'] = './input/'

    l = LinkHelpers.parse('abc.htm', '/123/')
    assert_equal './input/123/abc.htm', l.key

    l = LinkHelpers.parse('abc.htm', '/123/456/')
    assert_equal './input/123/456/abc.htm', l.key

    l = LinkHelpers.parse('/123/abc.htm', '/123/456/')
    assert_equal './input/123/abc.htm', l.key
  end


  def test_link_helpers_parser_disregards_index
    CONFIG['directories']['input'] = './input/'

    l = LinkHelpers.parse('index.htm', '/123/')
    assert_equal './input/123/', l.key

    l = LinkHelpers.parse('index.html', '/123/456/')
    assert_equal './input/123/456/', l.key

    l = LinkHelpers.parse('/123/index.htm', '/123/456/')
    assert_equal './input/123/', l.key
  end


  def test_special_resolvers_return_nil_for_regular_links
    link = LinkHelpers.new('/some/url/thing.htm')
    refute LinkHelpers.special_resolvers(link)
    link = LinkHelpers.new('some/url/thing.html')
    refute LinkHelpers.special_resolvers(link)
    link = LinkHelpers.new('somewhere/here')
    refute LinkHelpers.special_resolvers(link)
  end


  def test_special_resolvers_return_ids_for_glossary_links
    link = LinkHelpers.new('/GlossaryItem.htm?GID=227')
    id = LinkHelpers.special_resolvers(link)
    assert_equal id, CONFIG['ids']['glossary']

    link = LinkHelpers.new('/glossaryitem.htm?GID=276')
    id = LinkHelpers.special_resolvers(link)
    assert_equal id, CONFIG['ids']['glossary']

    link = LinkHelpers.new('/glossary.htm?GID=276')
    id = LinkHelpers.special_resolvers(link)
    assert_equal id, CONFIG['ids']['glossary']
  end


  def test_special_resolvers_return_ids_for_redirects
    CONFIG['directories']['input'] = './test/mocks/'

    $r.hset './test/mocks/curriculum-support/Teacher-Education/In-service/CSP/', 'id', '123'
    $r.log_key './test/mocks/curriculum-support/Teacher-Education/In-service/CSP/'

    link = LinkHelpers.new('/index-test')
    id = LinkHelpers.special_resolvers(link)
    assert_equal '123', id

    link = LinkHelpers.new('/glossaryitem.htm?GID=276')
    id = LinkHelpers.special_resolvers(link)
    assert_equal id, CONFIG['ids']['glossary']

    link = LinkHelpers.new('/glossary.htm?GID=276')
    id = LinkHelpers.special_resolvers(link)
    assert_equal id, CONFIG['ids']['glossary']
  end
end
