source "https://rubygems.org"

ruby file: ".ruby-version"

gem "autoprefixer-rails"
# Use github version for Ruby v4 support
# There's nothing special about this ref, it's just the latest one when we wrote this.
gem "capybara-mechanize",
  github: "phillbaker/capybara-mechanize",
  ref: "9b3bc7993d0d2e89825a5181e39dd74719ab0de0"
gem "dartsass-sprockets"
gem "device_detector"
gem "high_voltage"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma", "~> 7"
gem "rack-canonical-host"
gem "rails", "~> 8.1.0"
gem "simple_form"

# Required for capybara-mechanize as of Ruby v4
gem "ostruct"

group :development do
  gem "web-console"
  gem "bundler-audit", require: false
end

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 6.0"
end

group :test do
  gem "capybara", "~> 3.0"
  gem "launchy"
  gem "orderly"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :production do
  gem "rack-timeout"
end
