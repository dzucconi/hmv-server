class Synthetic
  include WaveFile

  SAMPLE_RATE = 44100
  TWO_PI = 2 * Math::PI
  RANDOM_GENERATOR = Random.new
  PHONEMES = {
    aa: 217,
    ae: 286,
    ah: 328,
    ao: 463,
    aw: 456,
    ax: 456,
    ay: 300,
    b: 17,
    ch: 126,
    d: 47,
    dh: 168,
    eh: 193,
    er: 420,
    ey: 288,
    f: 93,
    g: 93,
    hh: 171,
    ih: 286,
    iy: 158,
    jh: 138,
    k: 93,
    l: 328,
    m: 185,
    n: 316,
    ng: 207,
    ow: 417,
    oy: 578,
    p: 94,
    r: 132,
    s: 298,
    sh: 308,
    t: 76,
    th: 256,
    uh: 315,
    uw: 434,
    v: 287,
    w: 330,
    wh: 352,
    y: 300,
    yu: 208,
    z: 320,
    zh: 192
  }

  def pause(length = 1.0, rate = 44100)
    cycle = [0.0] * (length * rate)
    Buffer.new(cycle, Format.new(:mono, :float, rate))
  end

  def speak(phoneme)
    key = phoneme.downcase.gsub(/[^a-z ]/i, '').to_sym
    wave_type = :sine
    frequency = 75.0 * (Synthetic::PHONEMES.keys.index(key) + 1)
    max_amplitude = 1.0
    samples = synthesize(wave_type, (10.0 / Synthetic::PHONEMES[key]), frequency, max_amplitude)

    # Wrap the array of samples in a Buffer, so that it can be written to a Wave file
    # by the WaveFile gem. Since we generated samples between -1.0 and 1.0, the sample
    # type should be :float
    WaveFile::Buffer.new(samples, WaveFile::Format.new(:mono, :float, 44100))
  end

  # The dark heart of NanoSynth, the part that actually generates the audio data
  def synthesize(wave_type, length, frequency, max_amplitude)
    position_in_period = 0.0
    position_in_period_delta = frequency / Synthetic::SAMPLE_RATE

    # Initialize an array of samples set to 0.0. Each sample will be replaced with
    # an actual value below.
    samples = [0.0] * (length * 44100)

    samples.size.times do |i|
      # Add next sample to sample list. The sample value is determined by
      # plugging position_in_period into the appropriate wave function.
      if wave_type == :sine
        samples[i] = x = Math::sin(position_in_period * Synthetic::TWO_PI) * max_amplitude
      elsif wave_type == :square
        samples[i] = (position_in_period >= 0.5) ? max_amplitude : -max_amplitude
      elsif wave_type == :saw
        samples[i] = ((position_in_period * 2.0) - 1.0) * max_amplitude
      elsif wave_type == :triangle
        samples[i] = max_amplitude - (((position_in_period * 2.0) - 1.0) * max_amplitude * 2.0).abs
      elsif wave_type == :noise
        samples[i] = Synthetic::RANDOM_GENERATOR.rand(-max_amplitude..max_amplitude)
      end

      position_in_period += position_in_period_delta

      # Constrain the period between 0.0 and 1.0.
      # That is, keep looping and re-looping over the same period.
      if (position_in_period >= 1.0)
        position_in_period -= 1.0
      end
    end

    samples
  end
end
