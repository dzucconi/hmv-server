class Output
  attr_reader :words, :pause, :buffers, :filename, :synth, :wave_type

  def initialize(words, wave_type)
    @synth = Synthetic.new
    @words = words
    @pause = synth.pause 0.1
    @wave_type = wave_type.nil? ? :sine : wave_type.to_sym
    generate!
  end

  def generate!
    @filename = Wave.concat buffers, Synthetic::SAMPLE_RATE
  end

  def buffers
    words.map.with_index { |phonemes, i|
      phonemes.map { |phoneme|
        synth.speak phoneme, wave_type
      }.tap { |word|
        word << pause unless i == words.size - 1
      }
    }.flatten
  end
end
