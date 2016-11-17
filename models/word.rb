class Word
  attr_reader :word, :phonemes

  def initialize(word, phonemes)
    @word = word
    @phonemes = phonemes.map { |phoneme| Phoneme.new(phoneme) }
  end

  def duration
    @duration || @phonemes.map(&:duration).reduce(:+)
  end

  def scale(duration)
    @duration = duration
  end

  def to_json(*)
    {
      word: word,
      duration: duration,
      phonemes: phonemes
    }.to_json
  end
end
