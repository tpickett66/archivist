class SomeModel < ActiveRecord::Base
  serialize(:random_array,Array)
  serialize(:some_hash,Hash)
  has_archive :indexes=>[:first_name,:last_name]

  def full_name
    "#{last_name}, #{first_name}"
  end
end
