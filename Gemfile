require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'
gem 'rails', '3.2.12'
gem 'thin'
gem 'mysql2'
gem 'activesupport'
gem "devise", ">= 2.1.0"
gem "devise_invitable", ">= 1.0.1"
gem 'devise-async'
gem "auto_strip_attributes", ">= 1.0"
gem 'delayed_job_active_record'
gem "simple_form"
gem "coderay"
gem 'postageapp'
gem "carrierwave"
gem "mini_magick"
gem 'foreman'
gem "rails_config"
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'yui-compressor'
  gem 'compass-rails'
end
gem 'jquery-rails', "2.1.4"
gem 'fancybox-rails'
gem 'codemirror-rails'
gem 'redactor-rails'
gem "bootstrap-sass"
gem 'bootswatch-rails'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails', :git => 'git://github.com/fameoflight/bootstrap-timepicker-rails.git'
gem 'font-awesome-sass-rails'

case HOST_OS
  when /darwin/i
    gem 'libv8', '~> 3.11.8.3'
    gem 'therubyracer', :platforms => :ruby
    gem 'eventmachine'
  when /linux/i
    gem 'libv8', '~> 3.11.8.3'
    gem 'therubyracer', :platforms => :ruby
    gem 'eventmachine'
  when /mswin|windows|mingw/i
    gem 'rb-fchange', :group => :development
    gem 'win32console', :group => :development
    gem 'rb-notifu', :group => :development
    gem 'eventmachine', "1.0.0.beta.4.1"
end

gem "rspec-rails", ">= 2.9.0", :group => [:development, :test]
gem "machinist", :group => :test
gem "factory_girl_rails", ">= 3.2.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test
gem "capybara", ">= 1.1.2", :group => :test
gem "database_cleaner", ">= 0.7.2", :group => :test
gem "launchy", ">= 2.1.0", :group => :test
gem "guard", ">= 0.6.2", :group => :development
gem "guard-bundler", ">= 0.1.3", :group => :development
gem "guard-rails", ">= 0.0.3", :group => :development
gem "guard-livereload", ">= 0.3.0", :group => :development
gem "guard-rspec", ">= 0.4.3", :group => :development
gem "guard-cucumber", ">= 0.6.1", :group => :development
