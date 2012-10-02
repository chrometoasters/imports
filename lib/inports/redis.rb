class Redis

  # Helper for getting and incrementing node id
  # value.

  def get_id
    $r.incr 'idcount'
    $r.get 'idcount'
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

    $r.del 'keys'
  end
end



# Initialize redis.
$r = Redis.new
$r.select CONFIG['db']

# Set node id incrementer to our safe offset.
$r.set 'idcount', CONFIG['ids']['safety']


# Set input directory path as having the eZPublish homepage node id.
$r.hset CONFIG['directories']['input'], 'id', CONFIG['ids']['homepage']
