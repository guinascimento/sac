require 'rubygems'
require 'cucumber/rake/task'

namespace :rcov do
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end

  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber"].invoke
  end
end

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "--format pretty"
end

task :all do |t|
  Rake::Task["cucumber"].invoke
end