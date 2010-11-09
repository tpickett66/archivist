class SomeModel < ActiveRecord::Base
  # acts_as_archive
  has_archive :indexes=>[:first_name,:last_name]
end
