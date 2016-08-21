source "https://rubygems.org"

ruby "2.3.0"
gem "sinatra", "~>1.4.6", :require => 'sinatra/base'
gem "sinatra-contrib"
gem "erubis"
gem "pg"
gem "json"
gem 'google-api-client', '~> 0.8.2', :require => 'google/api_client'
gem 'signet', '>=0.4.5'

group :development do
  gem 'rake'
  gem 'sqlite3'
end
group :production do
  gem 'puma'
end