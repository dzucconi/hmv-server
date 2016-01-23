class Output
  attr_reader :words, :pause, :buffers, :filename, :synth, :wave_type, :duration

  def initialize(words, duration = nil, wave_type = :sine)
    @synth = Synthetic.new
    @words = words
    @pause = synth.pause 0.1
    @duration = [duration.to_f, 30.0].min unless duration.nil?
    @wave_type = wave_type.nil? ? :sine : wave_type.to_sym
  end

  def generate!
    @filename = Wave.concat buffers, Synthetic::SAMPLE_RATE
  end

  def scaled
    durations = stream.map { |x| x[:duration] }
    stream.zip(scale durations, duration).map do |(utterance, scaled)|
      utterance.tap { |x| x[:duration] = scaled }
    end
  end

  def scale(unscaled, duration)
    total = unscaled.reduce(:+)
    precision = 10**10
    ratios = unscaled.map do |length|
      (length * precision) / (total * precision)
    end
    ratios.map { |ratio| ratio * duration }
  end

  def stream
    words.map.with_index { |phonemes, i|
      phonemes.map { |phoneme|
        key = Phonemes.key phoneme
        { phoneme: key, duration: Phonemes.duration(key) }
      }.tap do |word|
        word << { phoneme: :pause, duration: 0.1 } unless i == words.size - 1
      end
    }.flatten
  end

  def buffers
    (duration.nil? ? stream : scaled).map do |utterance|
      synth.speak utterance[:phoneme], utterance[:duration], wave_type
    end
  end
end
