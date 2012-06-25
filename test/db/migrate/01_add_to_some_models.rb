class AddToSomeModels < ActiveRecord::Migration
  def self.up
    add_column :some_models, :birth_date, :date
    add_column :some_models, :height, :integer
  end

  def self.down
    remove_column :some_models, :birth_date
    remove_column :some_models, :height
  end
end
