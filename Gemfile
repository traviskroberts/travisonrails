source "https://rubygems.org"
ruby "2.0.0"

gem "rails", "3.2.22"
gem "pg"
gem "jquery-rails"
gem "authlogic"
gem "stringex"
gem "will_paginate"
gem "newrelic_rpm"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
  gem "turbo-sprockets-rails3"
end

group :development do
  gem "capistrano", "~> 3.1"
  gem "capistrano-bundler", "~> 1.1.2"
  gem "capistrano-rbenv", "~> 2.0"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano3-unicorn", "~> 0.2.1"
  gem "dotenv-rails"
  gem "foreman"
  gem "pry-rails"
end

group :production do
  gem "unicorn"
end
