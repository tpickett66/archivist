#require dependancies eventhough starting a rails app will already have them in place
require 'rubygems'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'

#require the rest of Archivist's files
files = File.join(File.dirname(__FILE__),'**','*.rb')
Dir.glob(files).each do |file|
  require file
end

ActiveRecord::Base.send(:include, Archivist::Base)
ActiveRecord::Migration.send(:include,Archivist::Migration)
module Archivist
  def self.update(*models)
    models.each do |klass|
      if klass.respond_to?(:has_archive) && klass.has_archive?
        klass.create_archive_table
        klass.create_archive_indexes
      end
    end
  end
end

