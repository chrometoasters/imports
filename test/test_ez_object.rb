require './lib/inports'
Bundler.require(:test)

class TestEzObject < MiniTest::Unit::TestCase
  def test_inheriting_from_class_registers_class_as_descendent
    # class Thing < EzObject; end

    # Use eval dummy.
    assert_includes Thing, EzObject.inherited('dummy')
  end


end
