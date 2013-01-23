FactoryGirl.define do
  factory :some_model do
    first_name 'Scott'
    last_name 'Adams'
    random_array [1,2,3,4]
    some_hash { {:cat => 'Catbert'} }
  end

  factory :my_namespaced_model, class: Namespace::MyNamespacedModel, parent: :some_model

  factory :my_single_namespaced_model, class: Namespace::MySingleNamespacedModel, parent: :some_model
end
