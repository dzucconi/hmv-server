# frozen_string_literal: true
require 'digest'

class Output
  attr_reader :key, :stream, :synth

  def self.keyify(*inputs)
    Digest::SHA256.hexdigest(inputs.to_json)
  end

  def initialize(stream, synth)
    @key = self.class.keyify(stream, synth)
    @stream = stream
    @synth = synth
  end

  def filename
    "tmp/#{key}.wav"
  end

  def buffers
    @buffers ||= stream.phonemes.map do |phoneme|
      synth.speak phoneme
    end
  end

  def generate!
    @generated ||= Wave.concat buffers, Synthetic::SAMPLE_RATE, filename
  end

  def to_json(*)
    stream.to_json
  end
end
