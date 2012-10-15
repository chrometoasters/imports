require './lib/inports'
Bundler.require(:test)

class Testprocessor < MiniTest::Unit::TestCase

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
        EzPub::HandlerSets::Static << self

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

    @processor = Processor.new
  end


  def teardown
    $r.kill_keys
  end


  def test_handlers_successfully_registered
    assert_includes EzPub::HandlerSets::All, EzPub::Short
    assert_includes EzPub::HandlerSets::All, EzPub::Hello
    assert_includes EzPub::HandlerSets::Static, EzPub::Hello

  end


  def test_handle_iterates_through_descendants_returning_true_when_handled
    @processor.handle('hello')
    assert_equal "EzPub::Hello", $r.get('hello')

    assert @processor.handle('x')
    assert_equal "EzPub::Short", $r.get('x')
  end


  def test_handle_respects_order
    @processor.handle('nothing-at-all')
    assert_equal "EzPub::Short", $r.get('called')
  end


  def test_handle_returns_true_for_handled_paths
    refute @processor.handle('abcd')
    refute $r.get('abcd')
  end


  def test_handle_returns_flase_for_unhandled_paths
    refute @processor.handle('abcd')
    refute $r.get('abcd')
  end
end
