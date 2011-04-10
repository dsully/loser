# Go to http://wiki.merbivore.com/pages/init-rb

# Specify your dependencies in the Gemfile

use_orm :datamapper
use_test :rspec
use_template_engine :erb

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = 'cfe5feb70e6e75cf7eaf71e3451694785d1ad62e'  # required for cookie session store
  c[:session_id_key] = '_loser_session_id' # cookie session id key, defaults to "_session_id"
end

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  require 'facets/enumerable/sum'
  require 'facets/numeric/round'
  require 'facets/date'
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Merb::Mailer.config = { :sendmail_path => '/usr/sbin/sendmail' }
  Merb::Mailer.delivery_method = :sendmail
end
