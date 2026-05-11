source "https://rubygems.org"

ruby ">= 3.1.0"

gem "sinatra", "~> 4.0"
gem "puma", "~> 6.4"
gem "rackup", "~> 2.1"
gem "dotenv", "~> 3.1"

# For local SDK development before the gem is published:
#   PARCELWING_RUBY_PATH=../parcelwing-ruby bundle install
if ENV["PARCELWING_RUBY_PATH"]
  gem "parcelwing", path: ENV.fetch("PARCELWING_RUBY_PATH")
else
  gem "parcelwing", "~> 0.1.0"
end
