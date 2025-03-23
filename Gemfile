source "https://rubygems.org"

ruby "3.3.5"

gem "autoprefixer-rails"
gem "capybara-mechanize"
gem "device_detector"
gem "high_voltage"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma", "~> 5.6"
gem "rack-canonical-host"
gem "rails", "~> 8.0.0"
gem "sassc-rails"
gem "simple_form"

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
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :production do
  gem "rack-timeout"
end
