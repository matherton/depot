# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Depot::Application.initialize!

# Configure the RAILS mail settings - just using test for everything in this file. Chris says he uses the pony GEM as very like PHP mailer
Depot::Application.configure do
  config.action_mailer.delivery_method = :test
end