require './lib/inports'
Bundler.require(:test)

class TestPostProcessor < MiniTest::Unit::TestCase
  include PostProcessor
  include MediaPathHelper

  def setup
    $r.set 'idcount', CONFIG['ids']['start']

    CONFIG['directories']['input'] = './test/mocks/'


    # 8fea406115865c060932116f701e60e2
    $r.hset mediaize_path('./test/mocks/Case-studies/Classroom-practice/Electronics/BP609-remote-controlled-electronic-robots/images/609-resources2.jpg', 'images'), 'id', $r.get_id
    $r.log_key mediaize_path('./test/mocks/Case-studies/Classroom-practice/Electronics/BP609-remote-controlled-electronic-robots/images/609-resources2.jpg', 'images')

    file = File.open('./test/mocks/example_source_content.htm')
    @converted = to_ezp file.read
  end


  def teardown
    $r.kill_keys
  end


  def test_registering_key_adds_key_to_post_processor_list
    PostProcessor.register('somepath')
    assert_includes $r.lrange('post_process', 0, -1), 'somepath'
  end


  def test_returns_a_string
    assert_kind_of String, @converted
  end


  def test_carriage_returns_stripped_from_output
    refute_match /&#13;/, @converted
  end


  def test_title_is_removed
    refute_match '<title>Technology Curriculum Support: Introduction</title>', @converted
  end


  def test_top_level_heading_is_removed
    refute_match '<p class="header">Technology Curriculum Support</p>', @converted
  end


  def test_em_converted_to_emphasize
    refute_match '<em>', @converted
    assert_match '<emphasize>', @converted
  end


  def test_strong_remain
    assert_match '<strong>', @converted
  end


  def test_lists_remain
    assert_match '<ul>', @converted
    assert_match '<li>', @converted
  end


  def test_glossary_box_to_tag
    refute_match '<div class="glossarybox">', @converted
    assert_match '<custom name="glossarybox">', @converted
  end


  def test_p_to_paragraph
    refute_match '<p>', @converted
    assert_match '<paragraph>', @converted
  end


  def test_subheads_to_level_2_heading
    refute_match '<p class="subhead">Introduction</p>', @converted
    assert_match '<header level="2">Introduction</header>', @converted
  end


  def test_anchor_endpoints_to_anchor
    refute_match '<a name="curriculum" id="curriculum">', @converted
    assert_match '<anchor name="curriculum">', @converted
  end


  def test_a_to_link_for_unproblematic_links
    refute_match '<a href="#', @converted
    refute_match '<a href="http', @converted
    refute_match '<a href="mailto', @converted

    assert_match '<link href="#', @converted
    assert_match '<link href="http', @converted
    assert_match '<link href="mailto', @converted
  end


  def test_subsubhead_converted_to_heading3
    refute_match '<p class="subsubhead">', @converted
    assert_match '<header level="3">', @converted
  end


  def test_heading_converted_without_redundant_strong
    refute_match %r{<header level="3">\n?<strong>}, @converted
    refute_match %r{<header level="2">\n?<strong>}, @converted
  end


  def test_no_empty_paragraphs
    refute_match %r{<paragraph>\s*<\/paragraph>}, @converted
  end


  def test_images_converted
    refute_match '<img', @converted
    assert_match '<embed', @converted
  end


  def test_image_id_resolved
    assert_match 'object_id="8238101f03021090a2799fcf145103c3', @converted
  end
end
