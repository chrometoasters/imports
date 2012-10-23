require './lib/inports'
Bundler.require(:test)

class TestEzPubHandler < MiniTest::Unit::TestCase
  def setup
    # Remove existing handlers
    EzPub::HandlerSets::All.delete_if {true}

    eval %{

      class EzPub::Short < EzPub::Handler
        EzPub::HandlerSets::All << self

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


      class EzPub::Hello < EzPub::Handler
        EzPub::HandlerSets::All << self

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


  def test_parent_id_returns_parents_id
    CONFIG['ids']['safety'] = 50
    CONFIG['directories']['input'] = './test/'

    load './lib/inports/redis.rb'

    $r.hset './test/hello/', 'id', $r.get_id
    $r.log_key './test/hello/'

    $r.hset './test/another/', 'id', $r.get_id
    $r.log_key './test/another/'

    assert_equal '8238101f03021090a2799fcf145103c3', EzPub::Handler.parent_id('./test/hello/index.htm')
    assert_equal '8238101f03021090a2799fcf145103c3', EzPub::Handler.parent_id('./test/hello/thing.htm')
    assert_equal '074be90af66f157223e71ace9b4e0319', EzPub::Handler.parent_id('./test/another/what')
  end


  def test_parent_id_returns_homepage_id_from_config_for_root
    CONFIG['directories']['input'] = './thing/'
    CONFIG['ids']['homepage'] = 1

    load './lib/inports/redis.rb'

    assert_equal '1', EzPub::Handler.parent_id('./thing/what')
  end


  def test_parent_id_fails_on_orphaned_path
    assert_raises(Orphanity) { EzPub::Handler.parent_id('./z/') }
  end
end
