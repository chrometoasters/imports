require './lib/inports'
Bundler.require(:test)

class TestRedis < MiniTest::Unit::TestCase
  def setup
    # Set node id incrementer to our safe offset.
    $r.set 'idcount', CONFIG['ids']['start']

    # Set an id for generating unique filenames.
    $r.set 'unique-file-id', '1'

    # Set input directory path as having the eZPublish homepage remote id.
    $r.hset CONFIG['directories']['input'], 'id', CONFIG['ids']['homepage']

    # Set media folders paths as having the appropriate remote ids.
    $r.hset 'media:files:./', 'id', CONFIG['ids']['files']
    $r.hset 'media:images:./', 'id', CONFIG['ids']['images']
  end


  def teardown
    $r.kill_keys
  end


  def test_redis_is_present
    assert_equal 'PONG', $r.ping
  end


  def test_id_count_uses_config_value
    i = CONFIG['ids']['start']
    assert_equal i.to_s, $r.get('idcount')
  end


  def test_root_path_has_homepage_id_from_config
    i = CONFIG['ids']['homepage']
    assert_equal i.to_s, $r.hget(CONFIG['directories']['input'], 'id')
  end


  def test_redis_global_has_new_methods
    assert_includes $r.methods, 'get_id'
    assert_includes $r.methods, 'log_key'
    assert_includes $r.methods, 'kill_keys'
  end


  def test_get_id_returns_unique_ids
    initial = $r.get('idcount').to_i
    initial += 1
    refute_equal initial.to_s, $r.get_id
  end


  def test_log_key_adds_key_to_global_set
    refute $r.lpop('keys')

    $r.log_key 'test'

    assert_equal 'test', $r.lpop('keys')
  end


  def test_kill_keys_removes_all_keys
    $r.log_key '1'
    $r.set '1', 'hello!'

    $r.log_key '2'
    $r.set '2', 'hello!'

    $r.log_key '3'
    $r.set '3',  'hello!'

    $r.log_key '4'
    $r.set '4',  'hello!'

    assert $r.get '1'

    assert_equal 4, $r.llen('keys')

    $r.kill_keys

    refute $r.get '1'

    refute $r.exists 'keys'
  end


  def test_kill_keys_yields_keys
    $r.log_key '1'
    $r.log_key '2'
    a = []

    $r.kill_keys {|k| a << k}

    assert_equal ['1', '2'], a
  end


  def test_redis_case_insensitive
    $r.log_key 'ABC'
    refute_includes $r.lrange('keys', 0, -1), 'ABC'
    assert_includes $r.lrange('keys', 0, -1), 'abc'
  end
end
