source "https://rubygems.org"

ruby "2.7.2"

gem "autoprefixer-rails"
gem "bourbon", "~> 4.2.0"
gem "capybara-mechanize"
gem "flutie"
gem "high_voltage"
gem "neat", "~> 1.7.0"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma", "~> 5.3"
gem "rack-canonical-host"
# Use Github so that we get https://github.com/rails/sprockets-rails/pull/454.
# The sprockets-rails gem releases infrequently
# (https://rubygems.org/gems/sprockets-rails) so we can't use a released
# version.
gem "sprockets-rails", github: "rails/sprockets-rails", ref: "b0b380e"
gem "rails", "~> 6.0.3"
gem "sassc-rails"
gem "title"

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
end
