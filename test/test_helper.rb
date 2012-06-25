require 'rubygems'
require 'bundler/setup'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'
require 'active_resource'
require 'minitest/unit'
require 'shoulda'
require 'logger'
require "fileutils"
require 'ruby-debug'

ROOT_PATH = File.join(File.dirname(__FILE__), "..")

$LOAD_PATH << File.join(ROOT_PATH, 'lib')
require 'archivist'

def connection
  unless ActiveRecord::Base.connected?
    ActiveRecord::Base.logger = logger
    config_path = File.join(File.dirname(__FILE__),'config','database.yml')
    config = YAML.load(File.open(config_path))
    ActiveRecord::Base.configurations = config

    database = ENV["DB"] || "mysql"
    ActiveRecord::Base.establish_connection(config[database])
  end
  @connection ||= ActiveRecord::Base.connection
end

def logger
  return @logger if @logger
  FileUtils.mkdir_p("#{File.dirname(__FILE__)}/../log")
  log_path = File.expand_path(File.dirname(__FILE__)+'/../log/test.log')
  @logger = Logger.new(log_path)
end

class ActiveSupport::TestCase
  class_eval do
    use_transactional_fixtures = true
  end

  def column_list(table)
    connection.columns(table).collect{|c| c.name}
  end

  def teardown
    %w{some_models another_models archived_some_models archived_another_models}.each do |t|
      connection.execute("TRUNCATE TABLE #{t}")
    end
  end

  def seed_db
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
