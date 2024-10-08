require 'ridgepole/rails/rake_task'

namespace :ridgepole do
  desc 'Export the database schema to Schemafile'
  Ridgepole::Rails::RakeTask::Export.new

  desc 'Apply Schemafile to the database'
  Ridgepole::Rails::RakeTask::Apply.new
end

Rake.application.lookup('db:migrate').clear
desc 'Migrate the database by Ridgepole'
task 'db:migrate' => %w(ridgepole:apply ridgepole:export)

Rake.application.lookup('db:schema:dump').clear
desc 'Export the database schema to Schemafile'
task 'db:schema:dump' => 'ridgepole:export'

Rake.application.lookup('db:schema:load').clear
desc 'Apply Schemafile to the database'
task 'db:schema:load' => 'ridgepole:apply'

Rake.application.lookup('db:test:prepare').clear
task 'db:test:prepare' => 'db:test:purge' do
  Rake::Task['ridgepole:apply'].invoke('test')
end

%w(db:migrate:status db:rollback db:version).each do |name|
  Rake.application.lookup(name).clear
end
