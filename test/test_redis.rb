require './lib/inports'
Bundler.require(:test)

class TestRedis < MiniTest::Unit::TestCase
  def setup
    load './lib/inports/redis.rb'
  end


  def teardown
    $r.kill_keys
  end


  def test_redis_is_present
    assert_equal 'PONG', $r.ping
  end


  def test_id_count_uses_config_value
    i = CONFIG['ids']['safety']
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


  def test_get_id_returns_and_increments_id
    initial = $r.get('idcount').to_i
    initial += 1
    assert_equal initial.to_s, $r.get_id
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

end
