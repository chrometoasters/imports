require './lib/inports'
Bundler.require(:test)

class TestMediaPathHelper < MiniTest::Unit::TestCase
  include MediaPathHelper

  def setup
    EzPub::MediaFolder.store 'media:files:./input'
    EzPub::MediaFolder.store 'media:files:./input/folder'
    EzPub::MediaFolder.store 'media:images:./input'
    EzPub::MediaFolder.store 'media:images:./input/folder'
    EzPub::MediaFolder.store 'media:images:./input/imagefolder'
  end


  def teardown
    $r.kill_keys
  end


  def test_has_media_path_returns_boolean_if_parent_media_folder_exists
    assert has_media_path? './input/folder/file.xml', 'files'
    assert has_media_path? './input/folder/file.png', 'images'
    assert has_media_path? './input/imagefolder/file.jpg', 'images'

    refute has_media_path? './input/anotherfolder/file.pdf', 'files'
    refute has_media_path? './input/anotherfolder/image.jpg', 'images'
  end


  def test_create_media_path_creates_heirarchy_of_folders
    create_media_path('./input/ghosts/file.pdf', 'files')
    create_media_path('./input/ghosts/mysteries/images.gif', 'images')

    assert has_media_path?('./input/ghosts/some.pdf', 'files')
    assert has_media_path?('./input/another.pdf', 'files')

    assert has_media_path?('./input/ghosts/mysteries/images.gif', 'images')
    assert has_media_path?('./input/ghosts/images.gif', 'images')
    assert has_media_path?('./input/images.gif', 'images')
  end


  def test_create_media_path_gracefully_ignores_existing_heirarchy_members
    assert has_media_path?('./input/folder/file.pdf', 'files')

    id = $r.hget 'media:files:./input/folder', 'id'

    create_media_path('./input/folder/inner-folder/file.pdf', 'files')

    id_after = $r.hget 'media:files:./input/folder', 'id'

    assert_equal id, id_after

    assert has_media_path?('./input/folder/inner-folder/file.pdf', 'files')
  end


  def test_mediaize_correctly_prefixes_path
    str = mediaize_path './input/things/what.jpg', 'images'
    assert_equal "media:images:./input/things/what.jpg", str
  end
end
