require './lib/inports'
Bundler.require(:test)

class TestTechlinkUrl < MiniTest::Unit::TestCase
  include TechlinkUrl

  def test_techlink_url_creates_valid_url
    CONFIG['directories']['input'] = './input/'
    path = './input/Case-studies/things/index.htm'
    url = techlink_url path
    assert_equal url, 'http://techlink.org.nz/Case-studies/things/index.htm'
  end
end
