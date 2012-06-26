require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__),'db','migrate','01_add_to_some_models')

class MigrationTest < ActiveSupport::TestCase
  context "The Migrations module" do
    context "when migrating up" do
      setup do
        orig_stdout = $stdout
        $stdout = File.new('/dev/null','w')
        @old_columns = column_list("some_models")
        @old_archive = column_list("archived_some_models")
        AddToSomeModels.migrate(:up)
        @new_columns = column_list("some_models")
        puts @old_columns.inspect
        puts @new_columns.inspect
        @new_archive = column_list("archived_some_models")
        $stdout = orig_stdout
      end

      teardown do
        orig_stdout = $stdout
        $stdout = File.new('/dev/null','w')
        AddToSomeModels.migrate(:down)
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
        AddToSomeModels.migrate(:up)
        @old_columns = column_list("some_models")
        puts @old_columns*','
        @old_archive = column_list("archived_some_models")
        AddToSomeModels.migrate(:down)
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

    if ActiveRecord::VERSION::STRING >= "3.1"
      context "when generating new migrations in Rails 3.1+" do
        should "not munge up the timestamped file names" do
          # debugger
          next_number = AddToSomeModels.next_migration_number(1)
          assert_match /#{Time.now.utc.strftime("%Y%m%d%H%M%S")}/,next_number
        end
      end
    end
  end
end