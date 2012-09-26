task :app do
  require './lib/inports'
end

namespace :reset do
  task :output do
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
  Rake::Task['reset:output'].invoke
end

task :scratch do
    Rake::Task['app'].invoke
    require './test/scratch'
end
