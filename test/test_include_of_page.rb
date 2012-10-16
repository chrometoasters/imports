require './lib/inports'
Bundler.require(:test)

class TestIncludeOrPage < MiniTest::Unit::TestCase
  include IncludeOrPage

  def test_include_correctly_identifies_include_paths
    assert include? './some/path/thing.cfm'
    refute include? './some/path/thing'
    refute include? './some/path/thing.htm'
    refute include? './some/path/thing.html'
    refute include? './some/path/thing.jpg'
  end


  def test_page_correctly_identifies_page_paths
    assert page? './some/path/thing.htm'
    refute page? './some/path/thing'
    refute page? './some/path/thing.cfm'
    refute page? './some/path/thing.jpg'
  end
end
