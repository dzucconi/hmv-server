class Wave
  include WaveFile

  def self.concat(buffers, rate = Synthetic::SAMPLE_RATE, filename = "tmp/#{SecureRandom.uuid}.wav")
    Writer.new(filename, Format.new(:mono, :pcm_16, rate)) do |writer|
      buffers.each { |buffer| writer.write buffer }
    end
  end

  def self.concat_files(file_names, rate = Synthetic::SAMPLE_RATE, filename = "tmp/#{SecureRandom.uuid}.wav")
    Writer.new(filename, Format.new(:mono, :pcm_16, rate)) do |writer|
      file_names.each do |fn|
        Reader.new(fn).each_buffer(rate) do |buffer|
          writer.write(buffer)
        end
      end
    end
  end

  def self.buffer_to_file(buffer, rate = Synthetic::SAMPLE_RATE, filename = "tmp/#{SecureRandom.uuid}.wav")
    Writer.new(filename, Format.new(:mono, :pcm_16, rate)) do |writer|
      writer.write buffer
    end
  end
end
