# frozen_string_literal: true
class Synthetic
  include WaveFile

  attr_reader :shape, :octave

  AMPLITUDE = 1.0
  SAMPLE_RATE = 44_100
  TWO_PI = 2 * Math::PI
  RANDOM_GENERATOR = Random.new
  DEFAULT_SHAPE = :sine
  DEFAULT_OCTAVE = 3

  def initialize(shape, octave)
    @shape = shape || DEFAULT_SHAPE
    @octave = octave || DEFAULT_OCTAVE
  end

  def pause(duration = 1.0)
    Buffer.new(cycle(duration), Format.new(:mono, :float, SAMPLE_RATE))
  end

  def not_available(duration = 2.0)
    samples = synthesize(duration, freq(100))
    Buffer.new(samples, Format.new(:mono, :float, SAMPLE_RATE))
  end

  def freq(i)
    440.0 * (2.0**(i / 12.0))
  end

  def speak(phoneme)
    return pause(phoneme.duration) if phoneme.phoneme == :PAUSE
    return not_available(phoneme.duration, :noise) if phoneme.phoneme == :UNAVAILABLE

    phoneme.pitch(octave)

    frequency = phoneme.frequency
    samples = synthesize(phoneme.duration, frequency)

    Buffer.new(samples, Format.new(:mono, :float, SAMPLE_RATE))
  end

  def cycle(length)
    [0.0] * (length * SAMPLE_RATE)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def synthesize(length, frequency)
    position = 0.0
    position_delta = frequency / SAMPLE_RATE

    cycle(length).tap do |samples|
      samples.size.times do |i|
        # Add next sample to sample list. The sample value is determined by
        # plugging position into the appropriate wave function.
        case shape
        when :sine
          samples[i] = Math::sin(position * TWO_PI) * AMPLITUDE
        when :square
          samples[i] = position >= 0.5 ? AMPLITUDE : -AMPLITUDE
        when :saw
          samples[i] = ((position * 2.0) - 1.0) * AMPLITUDE
        when :triangle
          samples[i] = AMPLITUDE - (((position * 2.0) - 1.0) * AMPLITUDE * 2.0).abs
        when :noise
          samples[i] = RANDOM_GENERATOR.rand(-AMPLITUDE..AMPLITUDE)
        end

        position += position_delta

        # Constrain the period between 0.0 and 1.0
        position -= 1.0 if position >= 1.0
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def to_json(*)
    {
      shape: shape,
      octave: octave
    }.to_json
  end
end
