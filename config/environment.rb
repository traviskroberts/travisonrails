# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  
  # required gems
  config.gem 'rsl-stringex', :lib => 'stringex', :source => 'http://gems.github.com'

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Caching
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"

  # Your secret key for verifying cookie session data integrity.
  config.action_controller.session = {
    :session_key => '_travisonrails_v2_session',
    :secret      => 'd6d0485dfe671a295ae842fc4c08036cf012f0aba110a189cb2270d13ff0026c9f7e7d911d9a589426f19c8906ee22e8309354344ccd053b2442c301eef9d82f'
  }
end
