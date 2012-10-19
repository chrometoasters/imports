require './lib/inports'
Bundler.require(:test)

class TestHasValidIndex < MiniTest::Unit::TestCase
  include HasValidIndex

  def setup
    CONFIG['directories']['input'] = './test/mocks'
  end


  def test_has_valid_index_distinguishes
    assert has_valid_index?('./test/mocks/index-test-2')
    refute has_valid_index?('./test/mocks/index-test-3')
  end


  def test_has_valid_index_doesnt_accept_reidrects
    refute has_valid_index?('./test/mocks/index-test')
  end

  def test_has_valid_index_spots_html_as_well_as_html
    assert has_valid_index?('./test/mocks/index-test-4')
  end
end
