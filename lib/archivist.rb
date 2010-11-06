#require dependancy gems(these should already be here in non-test environments but it never hurts to be safe)
require 'rubygems'
gem 'activerecord','~>3.0.1'
require 'active_record'

#require the rest of Archivist's files
files = File.join('.','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

module Archivist

end

