source "https://rubygems.org"

ruby "2.7.4"

gem "autoprefixer-rails"
gem "capybara-mechanize"
gem "high_voltage"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma", "~> 5.3"
gem "rack-canonical-host"
gem "sprockets-rails", "~> 3.2.2"
gem "rails", "~> 6.1.0"
gem "sassc-rails"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 5.0"
end

group :test do
  gem "capybara", "~> 3.0"
  gem "launchy"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :production do
  gem "rack-timeout"
end
