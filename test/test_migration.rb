require File.join(File.dirname(__FILE__), 'test_helper')

class TestMigration < ActiveSupport::TestCase
  context "The Migrations module" do
    setup do
      build_test_db(:archive=>true)
    end
    context "when migrating up" do
      setup do
        orig_stdout = $stdout
        $stdout = File.new('/dev/null','w')
        @old_columns = column_list("some_models")
        @old_archive = column_list("archived_some_models")
        ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__),'migration'))
        @new_columns = column_list("some_models")
        @new_archive = column_list("archived_some_models")
        $stdout = orig_stdout
      end

      should "migrate the original table" do
        assert_equal ['birth_date','height'],(@new_columns - @old_columns)
      end

      should "migrate the archive table" do
        assert_equal ['birth_date','height'],(@new_archive - @old_archive)
      end
    end
    context "when migrating down" do
      setup do
        orig_stdout = $stdout
        $stdout = File.new('/dev/null','w')
        ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__),'migration'))
        @old_columns = column_list("some_models")
        puts @old_columns*','
        @old_archive = column_list("archived_some_models")
        ActiveRecord::Migrator.rollback(File.join(File.dirname(__FILE__),'migration'))
        @new_columns = column_list("some_models")
        @new_archive = column_list("archived_some_models")
        $stdout = orig_stdout
      end
      
      should "migrate the original table" do
        assert_equal ['birth_date','height'],(@old_columns - @new_columns)
      end

      should "migrate the archive table" do
        assert_equal ['birth_date','height'],(@old_archive - @new_archive)
      end

    end
  end
end
