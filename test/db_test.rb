require File.join(File.dirname(__FILE__), 'test_helper')

class DBTest < ActiveSupport::TestCase

  context "The DB module" do
    should "make models respond to create_archive_table" do
      assert SomeModel.respond_to?(:create_archive_table)
    end

    context "when create_archive_table is called" do
      setup do
        SomeModel.create_archive_table
      end

      should "create the archive table" do
        assert ActiveRecord::Base.connection.table_exists?("archived_some_models")
      end

      should "create the table with the same columns" do
        o_columns = SomeModel.columns.map{|c| c.name}
        n_columns = SomeModel::Archive.columns.map{|c| c.name}.reject{|n| n == "deleted_at"}
        assert_equal o_columns,n_columns
      end

      should "create the table with additional column 'deleted_at'" do
        columns = SomeModel::Archive.columns.map{|c| c.name}
        assert columns.include?("deleted_at")
      end
    end

    context "when create_archive_table is called when the association option is true" do
      setup do
        AnotherModel.create_archive_table
      end

      should "create a foreign key column" do
        columns = AnotherModel::Archive.columns.map(&:name)
        assert columns.include?("another_model_id")
      end
    end
  end
end
