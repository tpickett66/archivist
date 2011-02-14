require 'rubygems'
require 'bundler/setup'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'
require 'active_resource'
require 'test/unit'
require 'shoulda'
require 'logger'
require "fileutils"

ROOT_PATH = File.join(File.dirname(__FILE__), "..")

$LOAD_PATH << File.join(ROOT_PATH, 'lib')
require 'archivist'

def connection
  unless ActiveRecord::Base.connected?
    config_path = File.join(File.dirname(__FILE__),'db','config','database.yml')
    config = YAML.load(File.open(config_path))
    ActiveRecord::Base.configurations = config

    database = ENV["DB"] || "mysql"
    ActiveRecord::Base.establish_connection(config[database])
  end
  @connection ||= ActiveRecord::Base.connection
end

class ActiveSupport::TestCase
  class_eval do
    use_transactional_fixtures = true
  end

  def build_test_db(opts={:archive=>false})
    log_directory = File.join(ROOT_PATH, 'log')
    FileUtils.mkdir_p log_directory

    logger_file =  File.open(File.join(log_directory, 'test.log'),File::RDWR|File::CREAT)
    logger_file.sync = true
    ActiveRecord::Base.logger = Logger.new(logger_file)
  
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

    if opts[:archive]
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

  def column_list(table)
    connection.columns(table).collect{|c| c.name}
  end

  def insert_models
    build_test_db(:archive=>true)
    array = [1,2,3,4]
    hash = {:dog_name=>"Astro",:cat_name=>"Catbert"}
    connection.execute("INSERT INTO some_models 
                          (first_name,last_name,random_array,some_hash)
                        VALUES
                          ('Scott','Adams','#{array.to_yaml}','#{hash.to_yaml}'),
                          ('George','Jetson','#{array.to_yaml}','#{hash.to_yaml}')")
  end
end
connection
models = File.join(File.dirname(__FILE__),'models','**','*.rb')
Dir.glob(models).each do |model|
  require model
end
