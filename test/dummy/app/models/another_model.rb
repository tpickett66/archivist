class AnotherModel < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  has_archive :associate_with_original=>true
end