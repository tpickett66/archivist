module ThisModule
  def win;end
end
class SomeModel < ActiveRecord::Base
  serialize(:random_array,Array)
  serialize(:some_hash,Hash)
  has_archive :indexes=>[:first_name,:last_name],:included_modules=>ThisModule

  def full_name
    "#{last_name}, #{first_name}"
  end
end
