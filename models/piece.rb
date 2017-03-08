# frozen_string_literal: true
class Piece
  class << self
    def find(key)
      self.new(Saved.get(key))
    end

    def delete(key)
      Saved.delete(key)
    end

    def all
      Saved.all.map do |key|
        self.find(key)
      end
    end
  end

  attr_reader :key, :input, :output

  def initialize(options)
    @key = options[:key]
    @wav = options[:wav]
    @mp3 = options[:mp3]
    @input = options[:input]
    @output = options[:output]
  end

  def wav
    @wav ||= Storage.url @output.filename do
      @output.generate!
      File.open @output.filename
    end
  end

  def mp3
    @mp3 ||= Transcoder.convert(key)
  end

  def attrs
    {
      key: key,
      wav: wav,
      mp3: mp3,
      input: input,
      output: output
    }
  end

  def to_json(*)
    attrs.to_json
  end

  def save
    Saved.set key, attrs
  end

  def delete
    Saved.delete key
  end
end
