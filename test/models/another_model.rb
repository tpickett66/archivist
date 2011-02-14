class AnotherModel < ActiveRecord::Base
  has_archive :associate_with_original=>true
end
