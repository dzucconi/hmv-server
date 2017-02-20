# frozen_string_literal: true
class PhonemeStream
  attr_reader :words, :scalar, :scaled

  DEFAULTS = {
    scalar: 1.0
  }.freeze

  def initialize(words, params = {})
    options = DEFAULTS.merge(params)

    @words = words
    @scalar = options[:scalar] || 1.0
    @scaled = words.tap do |x|
      x.each { |word| word.scale(@scalar) }
    end
  end

  def duration
    scaled.map(&:duration).reduce(:+)
  end

  def phonemes
    scaled.map(&:phonemes).flatten
  end

  def to_json(*)
    scaled.to_json
  end
end
