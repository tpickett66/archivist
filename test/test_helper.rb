require 'rubygems'

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
