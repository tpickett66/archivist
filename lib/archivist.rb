#require dependancies eventhough starting a rails app will already have them in place
require 'rubygems'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'

#require the rest of Archivist's files
files = File.join('lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

ActiveRecord::Base.send(:include, Archivist::Base)

module Archivist

end

