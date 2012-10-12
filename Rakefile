require 'rake/testtask'

task :app do
  require './lib/inports'
end


Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
end


namespace :process do
  task :static do
    Rake::Task['app'].invoke
    @p = Processor.new(:handlers => EzPub::Handlers::Static)
    @p.ingest

    # @p.output(Xml)

  end

  task :content do
    Rake::Task['app'].invoke
    # @p = Processor.new(:handlers => EzPub::Handlers::Content)
    # @p.ingest

    # @p.clean_and_reference

    # @p.output(Xml)
  end

  task :all do
    Rake::Task['app'].invoke
  end
end


namespace :output do
  namespace :files do
    task :delete do
      Rake::Task['app'].invoke

      $term.agree($term.color('Wipe existing output?', :red))

      dir = CONFIG['directories']['output']['files']

      puts $term.color("Removing #{dir}", :green)
      FileUtils.remove_dir(dir, true)

      puts $term.color("Recreating fresh #{dir}", :green)
      FileUtils.mkdir(dir)
      FileUtils.touch(dir + '/.gitkeep')
    end
  end

  namespace :images do
    task :delete do
      Rake::Task['app'].invoke

      $term.agree($term.color('Wipe existing output?', :red))

      dir = CONFIG['directories']['output']['images']

      puts $term.color("Removing #{dir}", :green)
      FileUtils.remove_dir(dir, true)

      puts $term.color("Recreating fresh #{dir}", :green)
      FileUtils.mkdir(dir)
      FileUtils.touch(dir + '/.gitkeep')
    end
  end

  namespace :content do
    task :delete do
      Rake::Task['app'].invoke

      $term.agree($term.color('Wipe existing output?', :red))

      dir = CONFIG['directories']['output']['content']

      puts $term.color("Removing #{dir}", :green)
      FileUtils.remove_dir(dir, true)

      puts $term.color("Recreating fresh #{dir}", :green)
      FileUtils.mkdir(dir)
      FileUtils.touch(dir + '/.gitkeep')
    end
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

    $r.kill_keys { |k| puts $term.color("Deleting #{k}", :green) }
  end
end


task :scratch, :v do |t, args|
    # $ rake scratch[v]

    Rake::Task['app'].invoke
    args.with_defaults(:v => nil)
    $verbose = args[:v]
    require './scratch'
end
