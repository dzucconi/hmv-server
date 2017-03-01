# frozen_string_literal: true
class PhonemeStream
  attr_reader :words, :scalar, :scaled, :pause

  DEFAULTS = {
    scalar: 1.0
  }.freeze

  def initialize(words, params = {})
    options = DEFAULTS.merge(params)
    @words = words
    @scalar = options[:scalar]
    @pause = options[:pause]
    @scaled = words.tap do |xs|
      xs.each do |word|
        if !pause.nil? && word.pause?
          word.durate pause
        else
          word.scale @scalar
        end
      end
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
