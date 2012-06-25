require File.join(File.dirname(__FILE__), 'test_helper')

class TestArchivist < Test::Unit::TestCase
  context "The Archivist" do
    should "include Archivist::Base in ActiveRecord::Base" do
      assert ActiveRecord::Base.include?(Archivist::Base)
    end

    should "include Archivist::Migration in ActiveRecord::Migration" do
      assert ActiveRecord::Migration.include?(Archivist::Migration)
    end

    should "respond to Archivist.update" do
      assert Archivist.respond_to?(:update)
    end
  end
end
