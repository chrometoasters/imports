require './lib/inports'
Bundler.require(:test)

class TestEzObject < MiniTest::Unit::TestCase
  def teardown
    $r.kill_keys
  end


  def test_inheriting_from_class_registers_class_as_descendent
    eval "class Thing < EzObject; end"
    assert_includes EzObject.inherited('dummy class'), Thing
  end


  def test_handle_iterates_through_descendants

    # Going to need to mock the file structure so there are paths.

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
