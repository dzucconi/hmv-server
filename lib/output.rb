require 'byebug'

class Output
  attr_reader :text, :words, :buffers, :filename, :synth, :wave_type, :duration

  def initialize(options = {})
    options = { duration: nil, wave_type: :sine }.merge options.symbolize_keys

    @filename = options[:filename]
    @synth = Synthetic.new
    @text = options[:text]
    @words = options[:words] || Corrasable.new(@text).to_phonemes
    @duration = [options[:duration].to_f, 30.0].min unless options[:duration].nil?
    @wave_type = options[:wave_type].nil? ? :sine : options[:wave_type].to_sym
  end

  def generate!
    @filename = Wave.concat buffers, Synthetic::SAMPLE_RATE, @filename
  end

  def scaled
    return stream if duration.nil?
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
    words.map.with_index { |(word, phonemes), i|
      {
        word: word,
        phonemes: phonemes.map { |phoneme|
          key = Phonemes.key phoneme
          { phoneme: key, duration: Phonemes.duration(key) }
        }
      }
    }.flatten
  end

  def buffers
    scaled.map do |utterance|
      synth.speak utterance[:phoneme], utterance[:duration], wave_type
    end
  end

  def to_json
    split = text.split(' ')
    split = split.zip((split.size - 1).times.map { ' ' }).flatten.compact
    chunked = scaled.chunk { |x| x[:phoneme] == :pause }

    # output = chunked.zip(split).map do |(_, chunk), word|
    #   {
    #     word: word,
    #     duration: chunk.map { |x| x[:duration] }.reduce(:+)
    #   }
    # end
    # output.to_json

    {
      chunked: chunked.to_a,
      split: split.to_a
    }.to_json
  end
end
