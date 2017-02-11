require 'rake/testtask'
require 'dotenv/tasks'

Dir["./lib/tasks/*.rake"].each { |task| load task }

task default: [:test]

Rake::TestTask.new do |t|
  t.libs.push << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  t.warning = false
end
