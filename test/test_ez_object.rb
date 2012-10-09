require './lib/inports'
Bundler.require(:test)

class TestEzObject < MiniTest::Unit::TestCase
  def setup
    eval %{

      class EzShort < EzObject
        def self.mine?(path)
          true if path.length < 2
        end

        def self.store(path)
          $r.set path, self
          $r.log_key path
        end
      end


      class EzHello < EzObject
        def self.mine?(path)
          true if path == 'hello'
        end

        def self.store(path)
          $r.set path, self
          $r.log_key path
        end
      end

    }
  end


  def teardown
    $r.kill_keys
  end


  def test_inheriting_from_class_registers_class_as_descendent
    assert_includes EzObject.inherited('dummy class'), EzShort
  end


  def test_handle_iterates_through_descendants_calling_mine
    EzObject.handle('hello')
    assert_equal "TestEzObject::EzHello", $r.get('hello')

    EzObject.handle('x')
    assert_equal "TestEzObject::EzShort", $r.get('x')
  end



  def test_parent_id_returns_parents_id
    CONFIG['ids']['safety'] = 50
    CONFIG['ids']['homepage'] = 1
    CONFIG['directories']['input'] = './test'

    load './lib/inports/redis.rb'

    $r.hset './test/hello', 'id', $r.get_id
    $r.log_key './test/hello'
    $r.hset './test/another', 'id', $r.get_id
    $r.log_key './test/another'

    assert_equal '51', EzObject.parent_id('./test/hello/index.htm')
    assert_equal '51', EzObject.parent_id('./test/hello/thing.htm')
    assert_equal '52', EzObject.parent_id('./test/another/what')
  end


  def test_parent_id_returns_homepage_id_from_config_for_root
    CONFIG['directories']['input'] = './thing'
    CONFIG['ids']['homepage'] = 1

    load './lib/inports/redis.rb'

    assert_equal '1', EzObject.parent_id('./thing/what')
  end


  def test_parent_id_fails_on_orphaned_path
    assert_raises(Orphanity) { EzObject.parent_id('z') }
  end
end
