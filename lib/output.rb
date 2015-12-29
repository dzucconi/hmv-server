class Output
  attr_reader :words, :pause, :buffers, :filename, :synth

  def initialize(words)
    @synth = Synthetic.new
    @words = words
    @pause = synth.pause 0.05
    generate!
  end

  def generate!
    @filename = Wave.concat buffers, 44100
  end

  def buffers
    words.map.with_index { |phonemes, i|
      phonemes.map { |phoneme|
        synth.speak phoneme
      }.tap { |word|
        word << pause unless i == words.size - 1
      }
    }.flatten
  end
end
