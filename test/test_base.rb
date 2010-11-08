require 'test_helper'

class TestBase < Test::Unit::TestCase
  context "Archivist::Base" do
    should "make ActiveRecord::Base respond to has_archive" do
      assert ActiveRecord::Base.respond_to?(:has_archive)
    end

    should "make ActiveRecord::Base respond to acts_as_archive" do
      assert ActiveRecord::Base.respond_to?(:acts_as_archive)
    end
  end

  context "Models that call has_archive" do
    should "have subclass Archive" do
      assert_nothing_raised do
        archive = SomeModel::Archive
      end
    end
  end

  context "The Archive subclass" do
    should "not write updated timestamps" do
      assert !SomeModel::Archive.record_timestamps
    end
  end
  
  context "The archiving functionality" do
    setup do
      build_test_db({:archive=>true})
    end
    
    context "when calling #copy_to_archive directly" do
      setup do 
        insert_models
      end
      
      should "not delete the original if told not to" do
        SomeModel.copy_to_archive({:id=>1},false)
        assert !SomeModel.where(:id=>1).empty?
      end
      
      should "create a new entry in the archive when told not to delete" do
        SomeModel.copy_to_archive({:id=>1},false)
        assert !SomeModel::Archive.where(:id=>1).empty?
      end
      
      should "delete the original if not specified" do
        SomeModel.copy_to_archive(:id=>1)
        assert SomeModel.where(:id=>1).empty?
      end
      
      should "create a new entry in the archive if delete is not specified" do
        SomeModel.copy_to_archive(:id=>1)
        assert !SomeModel::Archive.where(:id=>1).empty?
      end
      
      should "update the archived info when previously archived" do
        SomeModel.copy_to_archive({:id=>1},false)
        SomeModel.where(:id=>1).first.update_attributes!(:first_name=>"Cindy",:last_name=>"Crawford")
        SomeModel.copy_to_archive(:id=>1)
        m = SomeModel::Archive.where(:id=>1).first
        assert_equal "Crawford",m.last_name
      end
      
      should "not create duplicate entries when previously copied" do
        SomeModel.copy_to_archive({:id=>1},false)
        SomeModel.where(:id=>1).first.update_attributes!(:first_name=>"Cindy",:last_name=>"Crawford")
        SomeModel.copy_to_archive(:id=>1)
        assert_equal 1,SomeModel::Archive.all.size
      end
    end
  end
end
