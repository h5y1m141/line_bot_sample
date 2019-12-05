# frozen_string_literal: true

ruby File.read(File.expand_path('.ruby-version', __dir__)).strip

source 'https://rubygems.org'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'mysql2'
gem 'rails', '5.2.3'
gem "rack-cors", ">= 1.0.4"
gem 'dotenv-rails'

# LINE Bot処理のために以下追加
gem 'statesman', '~> 5.0.0'
gem 'line-bot-api'

group :development do
  gem 'bootsnap', require: false
  gem 'listen'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
end
