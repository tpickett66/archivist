class SomeModel < ActiveRecord::Base
  # acts_as_archive
  serialize(:random_array,Array)
  serialize(:some_hash,Hash)
  has_archive :indexes=>[:first_name,:last_name]
end
