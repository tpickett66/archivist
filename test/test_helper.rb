# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shoulda'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase

  def column_list(table)
    ActiveRecord::Base.connection.columns(table).collect{|c| c.name}
  end

  # def teardown
  #   %w{some_models another_models archived_some_models archived_another_models}.each do |t|
  #     connection.execute("TRUNCATE TABLE #{t}")
  #   end
  # end
end
