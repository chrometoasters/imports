require './lib/inports'
Bundler.require(:test)


class TestString < MiniTest::Unit::TestCase
  def test_parentize_mixed_into_string
    assert_includes ''.methods, '_parentize'
  end


  def test_parentize_returns_string
    assert_instance_of String, 'string'._parentize
  end


  def test_parentize_shortens_path_one_level
    assert_equal './one1/b/c', './one1/b/c/d'._parentize
    assert_equal './2two/abc/abc', './2two/abc/abc/abc'._parentize
    assert_equal '/three/abc/abc', '/three/abc/abc/abc'._parentize
  end


  def test_parentize_shortens_path_one_level_disregarding_slash
    assert_equal './one1/b/c', './one1/b/c/d/'._parentize
    assert_equal './2two/a-b-c/a_b_c', './2two/a-b-c/a_b_c/a-b_c/'._parentize
    assert_equal '/three/b/c', '/three/b/c/d/'._parentize
  end


  def test_parentize_returns_self_if_not_a_path
    assert_equal '.1bc', '.1bc'._parentize
  end


  def test_parentize_shortens_all_way_down
    assert_equal '.', './a'._parentize
    assert_equal '.', './a/'._parentize
    assert_equal '', '/a'._parentize
    assert_equal '', '/a/'._parentize
  end
end
