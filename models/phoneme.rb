class Phoneme
  attr_reader :phoneme

  def initialize(phoneme)
    @phoneme = case phoneme
      when 'N/A'
        :UNAVAILABLE
      when ' '
        :PAUSE
      else
        phoneme.upcase.gsub(/[^a-z ]/i, '').to_sym
      end
  end

  def duration
    Phonemes.get(phoneme)[:duration] / 3_000.0
  end

  def index
    Phonemes.collection.keys.index(phoneme)
  end

  def note
    index - (Phonemes.collection.keys.size / 2)
  end

  def to_json(options = {})
    {
      phoneme: phoneme,
      index: index,
      duration: duration
    }.to_json
  end
end
