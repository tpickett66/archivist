require File.join(File.dirname(__FILE__), 'test_helper')

class BaseTest < ActiveSupport::TestCase

  context "The module Archivist::Base" do
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
      assert_nothing_raised do
        archive = Namespace::MyNamespacedModel::Archive
      end
    end

    should "respond to archive_indexes as a class method" do
      assert SomeModel.respond_to?(:archive_indexes)
    end

    should "respond to acts_as_archive?" do
      assert SomeModel.respond_to?(:acts_as_archive?)
    end

    should "respond to has_archive?" do
      assert SomeModel.respond_to?(:has_archive?)
    end

    should "respond to has_archive? with true" do
      assert SomeModel.has_archive?
    end

    should "respond_to? archive_options" do
      assert SomeModel.respond_to?(:archive_options)
    end

    should "return the options hash when archive_options is called" do
      options_hash = Archivist::Base::ARCHIVIST_DEFAULTS.merge({:associate_with_original=>true,:allow_multiple_archives=>true})
      assert_equal options_hash,AnotherModel.archive_options
    end

    context "with the associate_with_original option set to true" do
      should "cause the main class to have a has_many reflection to the achive class" do
        reflections = AnotherModel.reflect_on_all_associations(:has_many).map{|r| r.name}
        assert_match /archived_another_models/,reflections.join(',')
      end

      should "cause the Archive class to have a belongs_to reflection to the main class" do
        reflections = AnotherModel::Archive.reflect_on_all_associations(:belongs_to).map{|r| r.name}
        assert_match /another_models/,reflections.join(',')
      end
    end
  end

  context "The Archive subclass" do
    should "not write updated timestamps" do
      assert !SomeModel::Archive.record_timestamps
    end

    should "have the same serialized attributes as the parent" do
      assert_equal SomeModel.serialized_attributes,SomeModel::Archive.serialized_attributes
    end

    should "have the Archivist::Base::Archive included in it" do
      assert SomeModel::Archive.include?(Archivist::ArchiveMethods)
    end

    should "have the correct modules included when the included_modules option is set" do
      assert SomeModel::Archive.include?(ThisModule)
    end
  end
  
  context "The archiving functionality" do
    context "when using copy_self_to_archive and the associate_with_original option is set to true" do
      setup do
        @zapp = AnotherModel.create!(:first_name=>"Zapp",:last_name=>"Brannigan")
        @zapp.copy_self_to_archive
      end

      should "create a new archive record" do
        assert_equal 1,AnotherModel::Archive.count
      end

      should "create a child record" do
        assert_equal 1,@zapp.archived_another_models.size
      end
    end

    context "when calling #copy_to_archive directly" do
      setup do
        @my_model = FactoryGirl.create(:some_model)
      end

      should "not delete the original if told not to" do
        SomeModel.copy_to_archive({:id=>@my_model.id},false)
        assert SomeModel.exists?(@my_model.id)
      end

      should "allow the user to pass in a block" do
        block_called = false
        SomeModel.copy_to_archive({:id=>@my_model.id},false) do |archive|
          block_called = true
        end
        assert block_called
      end   

      should "create a new entry in the archive when told not to delete" do
        SomeModel.copy_to_archive({:id=>@my_model.id},false)
        assert !SomeModel::Archive.where({:id=>@my_model.id}).empty?
      end

      should "delete the original if not specified" do
        SomeModel.copy_to_archive({:id=>@my_model.id})
        assert SomeModel.where({:id=>@my_model.id}).empty?
      end

      should "create a new entry in the archive if delete is not specified" do
        SomeModel.copy_to_archive({:id=>@my_model.id})
        assert !SomeModel::Archive.where({:id=>@my_model.id}).empty?
      end

      should "update the archived info when previously archived" do
        SomeModel.copy_to_archive({:id=>@my_model.id},false)
        SomeModel.where({:id=>@my_model.id}).first.update_attributes!(:first_name=>"Cindy",:last_name=>"Crawford")
        SomeModel.copy_to_archive({:id=>@my_model.id})
        m = SomeModel::Archive.where({:id=>@my_model.id}).first
        assert_equal "Crawford",m.last_name
      end

      should "not create duplicate entries when previously copied" do
        SomeModel.copy_to_archive({:id=>@my_model.id},false)
        SomeModel.where({:id=>@my_model.id}).first.update_attributes!(:first_name=>"Cindy",:last_name=>"Crawford")
        SomeModel.copy_to_archive({:id=>@my_model.id})
        assert_equal 1,SomeModel::Archive.all.size
      end
    end

    context "when calling #delete on an existing record" do
      setup do
        @my_model = FactoryGirl.create(:some_model)
        @my_model.delete
      end

      should "archive the record in question" do
        assert SomeModel::Archive.find(@my_model.id)
      end

      should "remove the original record" do
        assert !SomeModel.exists?(@my_model.id)
      end

      should "not change a model's id" do
        @original = SomeModel.new
        @original.id = 15
        @original.first_name = "Clark"
        @original.last_name = "Wayne"
        @original.save
        SomeModel.find(15).destroy
        @archived = SomeModel::Archive.where(:id=>15)
        assert_equal "Wayne",@archived.first.last_name
      end
    end

    context "when calling #delete on an existing record of a namespaced model" do
      setup do
        @my_model = FactoryGirl.create(:my_namespaced_model)
        @my_model.delete
      end

      should "archive the record in question" do
        assert Namespace::MyNamespacedModel::Archive.find(@my_model.id)
      end
    end
    
    context "when calling #delete! on an existing record" do
      setup do
        @my_model = FactoryGirl.create(:some_model)
        @my_model.delete!
      end

      should "NOT archive the record in question" do
        assert !SomeModel::Archive.exists?(@my_model.id)
      end

      should "remove the original record" do
        assert !SomeModel.exists?(@my_model.id)
      end
    end

    context "when calling delete on a new record" do
      setup do
        m = SomeModel.new(:first_name=>"Fabio",:last_name=>"Lanzoni")
        m.delete
      end

      should "not archive the record" do
        assert SomeModel::Archive.where(:first_name=>"Fabio").empty?
      end
    end

    context "when calling destroy on an existing record" do
      setup do
        @my_model = FactoryGirl.create(:some_model)
        @my_model.destroy
      end

      should "archive the record in question" do
        assert SomeModel::Archive.exists?(@my_model.id)
      end

      should "remove the original record" do
        assert !SomeModel.exists?(@my_model.id)
      end
    end
    
    context "when calling destroy! on an existing record" do
      setup do
        @my_model = FactoryGirl.create(:some_model)
        @my_model.destroy!
      end

      should "NOT archive the record in question" do
        assert !SomeModel::Archive.exists?(@my_model.id)
      end

      should "remove the original record" do
        assert !SomeModel.exists?(@my_model.id)
      end
    end
    
    context "when calling delete_all without conditions" do
      setup do
        3.times do
          FactoryGirl.create(:some_model)
        end
        @count = SomeModel.count
        SomeModel.delete_all
      end

      should "empty the original table" do
        assert SomeModel.all.empty?
      end

      should "fill the archive table" do
        assert_equal @count,SomeModel::Archive.count
      end
    end
    
    context "when calling delete_all with conditions" do
      setup do
        @models = []
        2.times do
          @models << FactoryGirl.create(:some_model)
        end
        @mid = @models[1].id
        SomeModel.delete_all(:id=>@mid)
      end

      should "leave non_matching items in table" do
        assert_equal 1,SomeModel.all.size
      end

      should "remove matching items" do
        assert SomeModel.where(:id=>@mid).empty?
      end

      should "fill the archive table" do
        assert_equal 1,SomeModel::Archive.count
      end
    end
    
    context "when calling delete_all! without conditions" do
      setup do
        2.times do
          FactoryGirl.create(:some_model)
        end
        SomeModel.delete_all!
      end
      
      should "empty the original table" do
        assert SomeModel.all.empty?
      end
      
      should "NOT fill the archive table" do
        assert SomeModel::Archive.all.empty?
      end
    end
    
    context "when calling delete_all! with conditions" do
      setup do
        @models = []
        2.times do
          @models << FactoryGirl.create(:some_model)
        end
        @mid = @models[1].id
        SomeModel.delete_all!(:id=>@mid)
      end

      should "NOT fill the archive table" do
        assert_equal 0,SomeModel::Archive.count
      end
    end

    context "when restoring from the archive" do
      setup do
        @models = []
        2.times do
          @models << FactoryGirl.create(:some_model)
        end
        @mid = @models[1].id
        SomeModel.delete_all
      end

      context "with conditions" do
        setup do
          @mod = SomeModel::Archive.where(:id=>@mid).first
          SomeModel.copy_from_archive(:id=>@mid)
        end

        should "re-populate the original table" do
          assert_equal 1,SomeModel.count
        end

        should "remove the archived record" do
          assert SomeModel::Archive.where(:id=>@mid).empty?
        end

        should "restore with original id" do
          assert_equal @mod.first_name,SomeModel.where(:id=>@mid).first.first_name
        end
      end

      context "using restore_all" do
        setup do
          SomeModel.restore_all
        end

        should "repopulate the original table" do
          assert_equal 2,SomeModel.count
        end

        should "empty the archive table" do
          assert SomeModel::Archive.all.empty?
        end
      end
    end
  end
end
