task :app do
  require './lib/inports'
end


namespace :output do
  task :delete do
    Rake::Task['app'].invoke

    $term.agree($term.color('Wipe existing output?', :red))

    dir = CONFIG['directories']['output']

    puts $term.color("Removing #{dir}", :green)
    FileUtils.remove_dir(dir, true)

    puts $term.color("Recreating fresh #{dir}", :green)
    FileUtils.mkdir(dir)
    FileUtils.touch(dir + '/.gitkeep')
  end
end


task :reset do
  Rake::Task['output:delete'].invoke
  Rake::Task['logs:delete'].invoke
  Rake::Task['redis:clean'].invoke

end


namespace :logs do
  task :delete do
    Rake::Task['app'].invoke
    #$term.agree($term.color('Wipe logs?', :red))

    puts $term.color("Deleting logs", :green)

    FileUtils.rm Dir.glob('./log/*.log')
  end
end


namespace :redis do
  task :clean do
    Rake::Task['app'].invoke

    $term.agree($term.color('Delete all redis keys?', :red))

    $r.lrange('keys', 0, -1).each do |k|
      puts $term.color("Deleting #{k}", :green)
      $r.del k
    end

    $r.del 'keys'
  end
end


task :scratch do
    Rake::Task['app'].invoke
    require './test/scratch'
end


namespace :output do
  task :xml do
    Rake::Task['app'].invoke

    xml = XML.new

    puts $term.color("Generating XML output...", :green)

    path = xml.output $r.lrange('keys', 0, -1)

    puts $term.color("Output located at #{path}", :green)
  end
end
