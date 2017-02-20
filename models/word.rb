# frozen_string_literal: true
class Word
  attr_reader :word, :phonemes

  def initialize(word, phonemes)
    @word = word
    @phonemes = phonemes.map { |phoneme| Phoneme.new(phoneme) }
  end

  def duration
    phonemes.map(&:duration).reduce(:+)
  end

  def scale(scalar)
    phonemes.each do |phoneme|
      phoneme.scale(scalar)
    end

    phonemes
  end

  def to_json(*)
    {
      word: word,
      duration: duration,
      phonemes: phonemes
    }.to_json
  end
end
