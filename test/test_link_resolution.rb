require './lib/inports'
Bundler.require(:test)

class TestLinkResolution < MiniTest::Unit::TestCase
  include PostProcessor

  def setup
    $r.set 'idcount', CONFIG['ids']['start']

    CONFIG['directories']['input'] = './test/mocks/'

    # Setup endpoints.
    # 8238101f03021090a2799fcf145103c3
    $r.hset './test/mocks/achievement-objectives.htm', 'id', $r.get_id
    $r.log_key './test/mocks/achievement-objectives.htm'

    # 074be90af66f157223e71ace9b4e0319
    $r.hset './test/mocks/Learning-Objectives/', 'id', $r.get_id
    $r.log_key './test/mocks/Learning-Objectives/'

    # 8fea406115865c060932116f701e60e2
    $r.hset './test/mocks/link-resolution/achievement-objectives.htm', 'id', $r.get_id
    $r.log_key './test/mocks/link-resolution/achievement-objectives.htm'

    # 190cc4bfddadcf791a5c246a5bb85027
    $r.hset './test/mocks/link-resolution/Learning-Objectives/', 'id', $r.get_id
    $r.log_key './test/mocks/link-resolution/Learning-Objectives/'

    # 08e2c35e8117a07de59eb43c0cc877cb
    $r.hset './test/mocks/index-test-2/', 'id', $r.get_id
    $r.log_key './test/mocks/index-test-2/'

    # 63a3bbd480c01246630c314196819fca
    $r.hset './test/mocks/what.htm', 'id', $r.get_id
    $r.log_key './test/mocks/what.htm'


    file = File.open('./test/mocks/has_links.htm')
    @converted_1 = to_ezp(file.read, :path => './test/mocks/has_links.htm')

    file = File.open('./test/mocks/link-resolution/has_links_2.htm')
    @converted_2 = to_ezp(file.read, :path => './test/mocks/link-resolution/has_links_2.htm')
  end


  def teardown
    $r.kill_keys
  end


  def test_link_resolution
    assert_match '<link href="eznode://8238101f03021090a2799fcf145103c3">', @converted_1
    assert_match '<link href="eznode://074be90af66f157223e71ace9b4e0319">', @converted_1

    assert_match '<link href="eznode://8fea406115865c060932116f701e60e2">', @converted_2
    assert_match '<link href="eznode://190cc4bfddadcf791a5c246a5bb85027">', @converted_2
    assert_match '<link href="eznode://074be90af66f157223e71ace9b4e0319">', @converted_2
    assert_match '<link href="eznode://08e2c35e8117a07de59eb43c0cc877cb">', @converted_2
    assert_match '<link href="eznode://63a3bbd480c01246630c314196819fca">', @converted_2
  end


  def test_link_resolution_doesnt_nuke_external_links
    assert_match '<link href="http://thing.com">', @converted_2
  end
end
