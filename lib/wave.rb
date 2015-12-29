class Wave
  include WaveFile

  def self.concat(buffers, rate = 44100, file_name = SecureRandom.uuid)
    Writer.new("tmp/#{file_name}.wav", Format.new(:mono, :pcm_16, rate)) { |writer|
      buffers.each { |buffer| writer.write buffer }
    }.file_name
  end
end
