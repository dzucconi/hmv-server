class Wave
  include WaveFile

  def self.concat(buffers, rate = Synthetic::SAMPLE_RATE, file_name = SecureRandom.uuid)
    Writer.new("tmp/#{file_name}.wav", Format.new(:mono, :pcm_16, rate)) { |writer|
      buffers.each { |buffer| writer.write buffer }
    }.file_name
  end

  def self.concat_files(file_names, rate = Synthetic::SAMPLE_RATE, file_name = SecureRandom.uuid)
    Writer.new("tmp/#{file_name}.wav", Format.new(:mono, :pcm_16, rate)) { |writer|
      file_names.each do |fn|
        Reader.new(fn).each_buffer(rate) do |buffer|
          writer.write(buffer)
        end
      end
    }.file_name
  end

  def self.buffer_to_file(buffer, rate = Synthetic::SAMPLE_RATE, file_name = SecureRandom.uuid)
    Writer.new("tmp/#{file_name}.wav", Format.new(:mono, :pcm_16, rate)) { |writer|
      writer.write buffer
    }.file_name
  end
end
