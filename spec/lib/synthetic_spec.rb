# frozen_string_literal: true
require File.expand_path '../../helper.rb', __FILE__

describe 'Synthetic' do
  let(:synth) { Synthetic.new }

  describe '#cycle' do
    it 'initializes a period' do
      synth.cycle(Synthetic::SAMPLE_RATE * 0.000000001).must_equal [0.0]
      synth.cycle(Synthetic::SAMPLE_RATE * 0.000000002).must_equal [0.0, 0.0, 0.0]
    end
  end

  describe '#pause' do
    it 'generates a pause for the specified length of time in seconds' do
      synth.pause(1).samples.length.must_equal(Synthetic::SAMPLE_RATE)
      synth.pause(2).samples.length.must_equal(Synthetic::SAMPLE_RATE * 2)
    end
  end
end
