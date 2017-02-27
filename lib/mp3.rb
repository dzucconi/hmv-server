# frozen_string_literal: true
class Mp3
  def self.encode(buffers)
    encoder = LAME::Encoder.new
    encoder.configure do |config|
      config.bitrate = 128
      config.quality = 3
    end

    tmp = Tempfile.new

    buffers.each do |buffer|
      encoder.encode_float(buffer.samples, buffer.samples) do |mp3|
        tmp.write mp3
      end
    end

    tmp.rewind
    tmp
  end
end
