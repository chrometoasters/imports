class Redis
  require 'digest/md5'


  # Rendering Redis case insensitive as used in this script.
  # Check for existence of $r as multiple evaluation of this code
  # will cause StackToDeep exceptions.

  unless $r

    alias_method :orig_hget, :hget

    def hget(key, id)
      orig_hget(key.downcase, id)
    end

    alias_method :orig_hgetall, :hgetall

    def hgetall(key)
      orig_hgetall(key.downcase)
    end


    alias_method :orig_hset, :hset

    def hset(key, id, value)
      key = key.downcase
      orig_hset(key, id, value)
    end

    alias_method :orig_rpush, :rpush

    def rpush(key, value)
      key = key.downcase
      value = value.downcase
      orig_rpush(key, value)
    end

    alias_method :orig_del, :del

    def del(key)
      if key.class == String
        key = key.downcase
      elsif key.class == Array
        key.each {|s| s.downcase!}
      end

      orig_del(key)
    end
  end


  # Helper for getting and incrementing node id
  # value and returning a derived hash.

  def get_id(path = nil)
    $r.incr 'idcount'
    id = path || $r.get('idcount')
    Digest::MD5.hexdigest('not a date :D' + id )
  end


  # Helper for keeping track of all our keys
  # in the "keys" list.

  def log_key(k)
    $r.rpush 'keys', k
  end


  # Removes all keys referenced in 'keys' list.
  #
  # Yields each key as it runs.

  def kill_keys
    $r.lrange('keys', 0, -1).each do |k|

      yield k if block_given?

      $r.del k
    end

    $r.del 'post_process'
    $r.del 'keys'

    # Attempt to delete unhandled sets in the event of a broken run.
    5.times {|i| $r.del "unhandled-#{i}"}
  end
end



# Initialize redis.
$r = Redis.new
$r.select CONFIG['db']

# Set node id incrementer to our safe offset.
$r.set 'idcount', CONFIG['ids']['start']

# Set an id for generating unique filenames.
$r.set 'unique-file-id', '1'

# Set input directory path as having the eZPublish homepage remote id.
$r.hset CONFIG['directories']['input'], 'id', CONFIG['ids']['homepage']

# Set media folders paths as having the appropriate remote ids.
$r.hset 'media:files:./', 'id', CONFIG['ids']['files']
$r.hset 'media:images:./', 'id', CONFIG['ids']['images']
