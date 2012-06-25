require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'rake/testtask'
require 'active_record'
Bundler::GemHelper.install_tasks

task :default => :test

def connection
  unless ActiveRecord::Base.connected?
    config_path = File.join(File.dirname(__FILE__),'test','config','database.yml')
    config = YAML.load(File.open(config_path))
    ActiveRecord::Base.configurations = config

    database = ENV["DB"] || "mysql"
    ActiveRecord::Base.establish_connection(config[database])
  end
  @connection ||= ActiveRecord::Base.connection
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

namespace :db do
  task :create do
    #make sure we have a clean slate
    connection.execute("DROP TABLE IF EXISTS some_models")
    connection.execute("DROP TABLE IF EXISTS archived_some_models")
    connection.execute("DROP TABLE IF EXISTS another_models")
    connection.execute("DROP TABLE IF EXISTS archived_another_models")
    connection.execute("DROP TABLE IF EXISTS schema_migrations")

    #create a 'some_models' table
    connection.create_table(:some_models) do |t|
      t.string :first_name
      t.string :last_name
      t.string :random_array
      t.string :some_hash
    end

    connection.create_table(:another_models) do |t|
      t.string :first_name
      t.string :last_name
    end

    # create a archived_some_models table
    connection.create_table(:archived_some_models) do |t|
      t.string :first_name
      t.string :last_name
      t.string :random_array
      t.string :some_hash
      t.datetime :deleted_at
    end

    connection.create_table(:archived_another_models) do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :deleted_at
      t.integer :another_model_id
    end
  end
end