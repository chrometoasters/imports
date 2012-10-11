require './lib/inports'
Bundler.require(:test)

class TestEzObject < MiniTest::Unit::TestCase
  def setup
    # Remove actual children first time
    unless EzPub.const_defined?('Short') || EzPub.const_defined?('Hello')
      EzPub::Object.descendants = []
    end

    eval %{

      class EzPub::Short < EzPub::Object
        def self.priority
          2
        end

        def self.mine?(path)
          # For checking order
          $r.log_key 'called'
          $r.set 'called', self

          true if path.length < 2
        end

        def self.store(path)
          $r.set path, self
          $r.log_key path
        end
      end


      class EzPub::Hello < EzPub::Object
        def self.priority
          1
        end

        def self.mine?(path)
          # For checking order
          $r.log_key 'called'
          $r.set 'called', self

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
    assert_includes EzPub::Object.descendants, EzPub::Short
    assert_includes EzPub::Object.descendants, EzPub::Hello
  end


  def test_handle_iterates_through_descendants_returning_true_when_handled
    assert EzPub::Object.handle('hello')
    assert_equal "EzPub::Hello", $r.get('hello')

    assert EzPub::Object.handle('x')
    assert_equal "EzPub::Short", $r.get('x')
  end


  def test_handle_respects_order
    EzPub::Object.handle('nothing-at-all')
    assert_equal "EzPub::Short", $r.get('called')
  end


  def test_handle_returns_true_for_handled_paths
    refute EzPub::Object.handle('abcd')
    refute $r.get('abcd')
  end


  def test_handle_returns_flase_for_unhandled_paths
    refute EzPub::Object.handle('abcd')
    refute $r.get('abcd')
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

    assert_equal '51', EzPub::Object.parent_id('./test/hello/index.htm')
    assert_equal '51', EzPub::Object.parent_id('./test/hello/thing.htm')
    assert_equal '52', EzPub::Object.parent_id('./test/another/what')
  end


  def test_parent_id_returns_homepage_id_from_config_for_root
    CONFIG['directories']['input'] = './thing'
    CONFIG['ids']['homepage'] = 1

    load './lib/inports/redis.rb'

    assert_equal '1', EzPub::Object.parent_id('./thing/what')
  end


  def test_parent_id_fails_on_orphaned_path
    assert_raises(Orphanity) { EzPub::Object.parent_id('z') }
  end
end
