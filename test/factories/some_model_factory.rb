FactoryGirl.define do
  factory :some_model do
    first_name 'Scott'
    last_name 'Adams'
    random_array [1,2,3,4]
    some_hash { {:cat => 'Catbert'} }
  end
end