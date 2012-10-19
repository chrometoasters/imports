require './lib/inports'
Bundler.require(:test)

class TestIsARedirect < MiniTest::Unit::TestCase
  include IsARedirect

  def setup
    CONFIG['directories']['input'] = './test/mocks'
  end


  def test_distinguishes_redirects_from_regular_files
    assert redirect?('./test/mocks/index-test/index.htm')
    refute redirect?('./test/mocks/index-test/index.htm-2')
  end

end
