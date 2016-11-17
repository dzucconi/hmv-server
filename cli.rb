require 'json'
require 'optparse'
require 'securerandom'
require 'digest/sha1'
require 'wavefile'
require 'oj'
require 'typhoeus'

require_relative './config/initializers/object'
require_relative './config/initializers/hash'
require_relative './lib/corrasable'
require_relative './lib/output'
require_relative './lib/synthetic'
require_relative './lib/wave'
require_relative './lib/phonemes'

{}.tap do |options|
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby cli.rb -d 5 -w 'hello world'"
    opts.on('-t', '--text TEXT', 'Text') { |xs| options[:text] = xs }
    opts.on('-d', '--duration DURATION', 'Duration') { |x| options[:duration] = x.to_f }
  end.parse!
end.let do |options|
  output = Output.new(
    text: options[:text],
    duration: options[:duration],
    filename: Digest::SHA1.hexdigest([options[:text], options[:duration]].compact.join('_'))
  )
  output.generate!

  json_filename = output.filename.gsub '.wav', '.json'
  File.write json_filename, output.to_json

  p output.filename
  p json_filename
end
