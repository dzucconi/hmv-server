require 'rubygems'
require 'bundler'

Bundler.require

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end

require 'securerandom'
require 'sinatra/asset_pipeline'

%w(
  /config/initializers/**/*.rb
  /models/**/*.rb
  /lib/**/*.rb
  /templates/**/*.rb
)
  .map { |pattern| Dir[File.dirname(__FILE__) + pattern] }
  .flatten.each { |f| require(f) }

require './application'

run Application
