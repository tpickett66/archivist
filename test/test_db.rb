require 'test_helper'

class TestDb < Test::Unit::TestCase

  context "The DB module" do
    setup do
      build_test_db(:archive=>false)
    end

    should "make models respond to create_archive_table" do
      assert SomeModel.respond_to?(:create_archive_table)
    end

    context "when create_archive_table is called" do
      setup do
        SomeModel.create_archive_table
      end

      should "create the archive table" do
        assert connect_to_db.table_exists?("archived_some_models")
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
  end
end
