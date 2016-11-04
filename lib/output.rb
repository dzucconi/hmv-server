require 'digest'

class Output
  attr_reader :text, :words, :buffers, :key, :synth, :wave_type, :duration

  def initialize(options = {})
    options = { duration: nil, wave_type: :sine }.merge options.symbolize_keys

    @key = options[:key] || Digest::SHA256.hexdigest(options[:text])
    @synth = Synthetic.new
    @text = options[:text]
    @words = options[:words] || Corrasable.new(@text).to_phonemes
    @duration = [options[:duration].to_f, 30.0].min unless options[:duration].nil?
    @wave_type = options[:wave_type].nil? ? :sine : options[:wave_type].to_sym
  end

  def generate!
    Wave.concat buffers, Synthetic::SAMPLE_RATE, filename
  end

  def filename
    "tmp/#{key}.wav"
  end

  def scaled
    return stream if duration.nil?
    durations = stream.map(&:duration)
    stream
      .zip(scale(durations, duration))
      .map { |(word, scaled)| word.scale(scaled) }
      .map(&:phonemes)
      .flatten
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
    words.map(&:phonemes).flatten
  end

  def buffers
    scaled.map do |phoneme|
      synth.speak phoneme, wave_type
    end
  end

  def to_json
    words.to_json
  end
end
