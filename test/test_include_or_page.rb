require './lib/inports'
Bundler.require(:test)

class TestIncludeOrPage < MiniTest::Unit::TestCase
  include IncludeOrPage

  def test_include_correctly_identifies_include_paths
    assert include? './some/path/thing.cfm'

    refute include? './some/path/thing/'
    refute include? './some/path/thing.htm'
    refute include? './some/path/thing.html'
    refute include? './some/path/thing.jpg'
  end


  def test_page_correctly_identifies_page_paths
    assert page? './some/path/thing.htm'

    refute page? './some/path/thing/'
    refute page? './some/path/thing.cfm'
    refute page? './some/path/thing.jpg'
  end


  # Am I sure this is the desired behaviour?

  def test_page_doesnt_acknowledge_indexes
    refute page? './some/path/index.htm'
    refute page? './some/path/index.html'
  end


  def test_page_acknowledges_indexes_for_folders
    CONFIG['directories']['input'] = './test/mocks'
    assert page? './test/mocks/index-test-2/'
    refute page? './test/mocks/index-test/'
  end
end
