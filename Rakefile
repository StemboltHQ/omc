require "bundler/gem_tasks"

desc 'Open an pry (or irb) session'
task :console do
  begin
    require 'pry'
    sh 'pry -Ilib -romc'
  rescue LoadError => _
    sh 'irb -rubygems -Ilib -romc'
  end
end

task c: :console
