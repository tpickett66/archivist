require 'test_helper'

class TestArchivist < Test::Unit::TestCase
  context "The Archivist" do
    should "include Archivist::Base in ActiveRecord::Base" do
      assert ActiveRecord::Base.include?(Archivist::Base)
    end
  end
end
