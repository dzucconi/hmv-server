require 'optparse'
require 'securerandom'
require 'wavefile'
require 'oj'
require 'typhoeus'

require_relative './config/initializers/object'
require_relative './lib/corrasable'
require_relative './lib/output'
require_relative './lib/synthetic'
require_relative './lib/wave'
require_relative './lib/phonemes'

{}.tap { |options|
  OptionParser.new { |opts|
    opts.banner = "Usage: ruby cli.rb -d 5 -w \"hello world\""
    opts.on('-w', '--words WORDS', 'Words') { |xs| options[:words] = xs }
    opts.on('-d', '--duration DURATION', 'Duration') { |x| options[:duration] = x.to_f }
  }.parse!
}.let do |options|
  words = Corrasable.new(options[:words]).to_phonemes
  output = Output.new(words, {
    duration: options[:duration],
    filename: "#{options[:words].downcase.gsub(/[^0-9a-z]/i, '-')}_#{options[:duration].to_s.gsub('.', '-')}"
  })
  output.generate!
  p output.filename
end
