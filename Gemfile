source "https://rubygems.org"

ruby "2.5.3"

gem "autoprefixer-rails"
gem "bourbon", "~> 5.1.0"
gem "flutie"
gem "high_voltage"
gem "neat", "~> 1.7.0"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 5.2.2"
gem "sassc-rails"
gem "title"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.5"
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
  gem "rails_stdout_logging"
end
