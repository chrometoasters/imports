class Redis
  def get_id
    $r.incr 'idcount'
    $r.get 'idcount'
  end

  def log_key(k)
    $r.rpush 'keys', k
  end
end

$r = Redis.new
$r.select CONFIG['db']

$r.set 'idcount', CONFIG['ids']['safety']
$r.hset CONFIG['directories']['input'], 'id', CONFIG['ids']['homepage']
