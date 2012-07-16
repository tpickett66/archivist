# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
ENV['ADAPTER_TYPE'] = (RUBY_PLATFORM == 'java' ? 'jdbc' : 'native')

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shoulda'
require 'factory_girl'
if FactoryGirl.factories.first.nil?
  FactoryGirl.find_definitions
end

if RUBY_VERSION < "1.9" || RUBY_PLATFORM == 'java'
  require 'ruby-debug'
else
  require 'debugger'
end

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  def column_list(table)
    ActiveRecord::Base.connection.columns(table).collect{|c| c.name}
  end
end
