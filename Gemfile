# A sample Gemfile
source 'https://rubygems.org'

gemspec
gem 'appraisal'

group :test do
  gem 'rubocop', require: false
  gem 'reek', require: false
  gem 'simplecov', '>= 0.9.0', require: false
  gem 'coveralls', :require => false
end

group :local_development do
  gem 'terminal-notifier-guard', require: false if RUBY_PLATFORM.downcase.include?('darwin')
  gem 'guard-rspec', '>= 4.3.1' ,require: false
  gem 'guard-bundler', require: false
  gem 'guard-preek', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-cane', require: false
  gem 'guard-reek', github: 'pericles/guard-reek', require: false
  gem 'pry'
end
