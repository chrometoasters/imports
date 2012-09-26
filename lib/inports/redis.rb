class Redis
  def get_id
    $r.incr 'idcount'
    $r.get 'idcount'
  end

  def log_key(k)
    $r.sadd 'keys', k
  end
end

$r = Redis.new
$r.select CONFIG['db']

$r.set 'idcount', CONFIG['ids']['safety']
