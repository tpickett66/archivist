require File.join(File.dirname(__FILE__), 'test_helper')

class ArchiveTest < ActiveSupport::TestCase
  context "The module Archivist::ArchiveMethods" do
    should "give the Archive subclass the super's methods" do
      assert_nothing_raised do
        model = SomeModel::Archive.new(:first_name=>"Steve",:last_name=>"Smith")
        model.full_name
      end
    end

    should "make the Archive subclass respond_to? correctly" do
      assert SomeModel::Archive.new.respond_to?(:full_name)
    end

    should "now about its original class name" do
      assert_equal '::Namespace::MyNamespacedModel', Namespace::MyNamespacedModel::Archive.new.__send__(:get_klass_name)
    end

    should "now about its original class" do
      assert_equal ::Namespace::MyNamespacedModel, Namespace::MyNamespacedModel::Archive.new.__send__(:get_klass)
    end
  end
end
