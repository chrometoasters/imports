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


namespace :delete do
  namespace :helpers do
    task :output, :section, :silent do |t, args|
      section = args[:section]
      silent = args[:silent] || nil

      Rake::Task['app'].invoke

      unless silent
        $term.agree($term.color("Wipe existing #{section} output?", :red))
      end

      dir = CONFIG['directories']['output'][section]

      puts $term.color("Removing #{dir}", :green)
      FileUtils.remove_dir(dir, true)

      puts $term.color("Recreating fresh #{dir}", :green)
      FileUtils.mkdir(dir)
      FileUtils.touch(dir + '/.gitkeep')
    end
  end


  task :logs, :silent do |t, args|
    Rake::Task['app'].invoke

    silent = args[:silent] || nil

    unless silent
      $term.agree($term.color('Wipe all logs?', :red))
    end

    puts $term.color("Deleting logs", :green)

    FileUtils.rm Dir.glob('./log/*.log')
  end


  task :keys, :silent do |t, args|
    Rake::Task['app'].invoke

    silent = args[:silent] || nil

    unless silent
      $term.agree($term.color('Delete all redis keys?', :red))
    end

    $r.kill_keys { |k| puts $term.color("Deleting #{k}", :yellow) }
  end


  namespace :output do
    task :files, :silent do |t, args|
      Rake::Task['delete:helpers:output'].reenable
      Rake::Task['delete:helpers:output'].invoke('files', args[:silent])
    end

    task :images, :silent do |t, args|
      Rake::Task['delete:helpers:output'].reenable
      Rake::Task['delete:helpers:output'].invoke('images', args[:silent])
    end

    task :static, :silent do |t, args|
      Rake::Task['delete:output:files'].invoke(args[:silent])
      Rake::Task['delete:output:images'].invoke(args[:silent])
    end

    task :content, :silent do |t, args|
      Rake::Task['delete:helpers:output'].reenable
      Rake::Task['delete:helpers:output'].invoke('content', args[:silent])
    end

    task :all, :silent do |t, args|
      Rake::Task['delete:output:files'].invoke(args[:silent])
      Rake::Task['delete:output:images'].invoke(args[:silent])
      Rake::Task['delete:output:content'].invoke(args[:silent])
    end
  end
end


task :flush do
  Rake::Task['delete:keys'].invoke('shh')
  Rake::Task['delete:output:all'].invoke('shh')
  Rake::Task['delete:logs'].invoke('shh')
end


task :scratch, :v do |t, args|
    # $ rake scratch[v]

    Rake::Task['app'].invoke
    args.with_defaults(:v => nil)
    $verbose = args[:v]
    require './scratch'
end
