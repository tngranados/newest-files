# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

desc 'Build the gem'
task :build do
  system 'gem build newest_files.gemspec'
end

desc 'Install the gem locally'
task install: :build do
  system 'gem install newest_files-*.gem'
end

desc 'Release the gem'
task release: :build do
  system 'gem push newest_files-*.gem'
end
