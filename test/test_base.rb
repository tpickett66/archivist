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
end
