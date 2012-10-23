require './lib/inports'
Bundler.require(:test)


class TestString < MiniTest::Unit::TestCase
  def test_parentize_mixed_into_string
    assert_includes ''.methods, '_parentize'
  end


  # replace with test for exception
  # def test_parentize_returns_string
  #   assert_instance_of String, 'string'._parentize
  # end


  def test_parentize_shortens_path_one_level
    assert_equal './one1/b/c/', './one1/b/c/d'._parentize
    assert_equal './2two/abc/abc/', './2two/abc/abc/abc'._parentize
    assert_equal '/three/abc/abc/', '/three/abc/abc/abc'._parentize
  end


  def test_parentize_ignores_directories
    assert_equal './one1/b/c/d/', './one1/b/c/d/'._parentize
    assert_equal './2two/a-b-c/a_b_c/a-b_c/', './2two/a-b-c/a_b_c/a-b_c/'._parentize
    assert_equal '/three/b/c/d/', '/three/b/c/d/'._parentize
  end


  # Is this desirable behaviour?
  # def test_parentize_returns_self_if_not_a_path
  #   assert_equal '.1bc', '.1bc'._parentize
  # end


  def test_parentize_handles_spaces
    assert_equal './input/', './input/curriculum support'._parentize
  end


  def test_parentize_shortens_all_way_down
    assert_equal './', './a'._parentize
    assert_equal './a/', './a/'._parentize
    assert_equal '/', '/a'._parentize
    assert_equal '/a/', '/a/'._parentize
  end


  def test_parentize_handles_media_paths
    assert_equal 'media:files:./a/b/', 'media:files:./a/b/hello.jpg'._parentize
    assert_equal 'media:files:./a/', 'media:files:./a/b'._parentize
    assert_equal 'media:files:./', 'media:files:./a'._parentize
  end


  def test_explode_fields_returns_array_of_hashes
    a = 'fieldname:type,anotherfield:anothertype,finalfield:type'._explode_fields

    assert_kind_of Array, a
    assert_equal 3, a.length

    assert_kind_of Hash, a.first
    assert_equal a.first, {'fieldname' => 'type'}
    assert_equal a[2], {'finalfield' => 'type'}
  end
end
