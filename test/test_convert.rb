require './lib/inports'
Bundler.require(:test)

class TestConvert < MiniTest::Unit::TestCase
  include Convert

  def setup
    file = File.open('./test/mocks/example_source_content.htm')
    @converted = to_ezp file.read
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
end
