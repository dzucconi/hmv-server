# frozen_string_literal: true
require 'sinatra/asset_pipeline/task'
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra/asset_pipeline'
require './application'

Sinatra::AssetPipeline::Task.define! Application

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
