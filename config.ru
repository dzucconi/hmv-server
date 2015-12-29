require 'rubygems'
require 'bundler'

Bundler.require

require 'securerandom'
require 'sinatra/asset_pipeline'

%w(
  /config/initializers/**/*.rb
  /lib/**/*.rb
)
  .map { |pattern| Dir[File.dirname(__FILE__) + pattern] }
  .flatten.each { |f| require(f) }

require './application'

run Application
