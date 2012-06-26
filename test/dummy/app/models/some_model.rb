require 'this_module'

class SomeModel < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :random_array, :some_hash
  serialize(:random_array,Array)
  serialize(:some_hash,Hash)
  has_archive :indexes=>[:first_name,:last_name],:included_modules=>ThisModule

  def full_name
    "#{last_name}, #{first_name}"
  end
end