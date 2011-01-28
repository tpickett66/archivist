require 'rubygems'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'
require 'active_resource'
require 'test/unit'
require 'shoulda'
require 'logger'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'archivist'

class Test::Unit::TestCase

end

def connection
  unless ActiveRecord::Base.connected?
    config_path = File.join(File.dirname(__FILE__),'db','config','database.yml')
    config = YAML.load(File.open(config_path))
    ActiveRecord::Base.configurations = config
    ActiveRecord::Base.establish_connection(config['mysql'])
  end
  @connection ||= ActiveRecord::Base.connection
end

def build_test_db(opts={:archive=>false})
  logger_file =  File.open(File.join(File.dirname(__FILE__),'..','log','test.log'),File::RDWR|File::CREAT)
  logger_file.sync = true
  ActiveRecord::Base.logger = Logger.new(logger_file)
  
  #make sure we have a clean slate
  connection.execute("DROP TABLE IF EXISTS some_models")
  connection.execute("DROP TABLE IF EXISTS archived_some_models")
  connection.execute("DROP TABLE IF EXISTS schema_migrations")
  
  #create a 'some_models' table
  connection.create_table(:some_models) do |t|
    t.string :first_name
    t.string :last_name
  end
  
  if opts[:archive]
    # create a archived_some_models table
    connection.create_table(:archived_some_models) do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :deleted_at
    end
  end
end

def column_list(table)
  connection.columns(table).collect{|c| c.name}
end

def insert_models
  SomeModel.create(:first_name=>"Heidi",:last_name=>"Klum")
  SomeModel.create(:first_name=>"Adriana",:last_name=>"Lima")
end

connection

require File.join(File.dirname(__FILE__),'models','some_model')
