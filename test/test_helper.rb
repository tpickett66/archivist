require 'rubygems'
gem 'activerecord','~>3.0.1' #enforce rails 3+
require 'active_record'
require 'test/unit'
require 'shoulda'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'archivist'

#put custom assertions here
class Test::Unit::TestCase

end

class SomeModel < ActiveRecord::Base
  has_archive
end

class AAAModel < ActiveRecord::Base
  #acts_as_archive
end
