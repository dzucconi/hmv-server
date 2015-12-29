class Synthetic
  include WaveFile

  AMPLITUDE = 1.0

  SAMPLE_RATE = 44100

  TWO_PI = 2 * Math::PI

  RANDOM_GENERATOR = Random.new

  def pause(length = 1.0)
    Buffer.new(cycle(length), Format.new(:mono, :float, SAMPLE_RATE))
  end

  def freq(i)
    440.0 * (2.0 ** (i / 12.0))
  end

  def speak(phoneme, wave_type = :sine)
    key = phoneme.downcase.gsub(/[^a-z ]/i, '').to_sym
    frequency = freq(Phonemes.index(key))
    samples = synthesize(wave_type, (10.0 / Phonemes.duration(key)), frequency)
    Buffer.new(samples, Format.new(:mono, :float, SAMPLE_RATE))
  end

  def cycle(length)
    [0.0] * (length * SAMPLE_RATE)
  end

  def synthesize(wave_type, length, frequency)
    position = 0.0
    position_delta = frequency / SAMPLE_RATE
    cycle(length).tap do |samples|
      samples.size.times do |i|
        # Add next sample to sample list. The sample value is determined by
        # plugging position into the appropriate wave function.
        case wave_type
        when :sine
          samples[i] = Math::sin(position * TWO_PI) * AMPLITUDE
        when :square
          samples[i] = (position >= 0.5) ? AMPLITUDE : -AMPLITUDE
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
end
