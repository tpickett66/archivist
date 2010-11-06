$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'archivist'
require 'shoulda'
require 'test/unit'

class ArchivableModel < ActiveRecord::Base
  #has_archive
end

class AAAModel < ActiveRecord::Base
  #acts_as_archive
end
