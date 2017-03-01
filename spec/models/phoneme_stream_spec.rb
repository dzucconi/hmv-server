# frozen_string_literal: true
require File.expand_path '../../helper.rb', __FILE__

describe 'PhonemeStream' do
  before(:each) do
    @words = Corrasable.cast([%w(HH AH0 L OW1), %w(W ER1 L D)])
  end

  describe '#key' do
    it 'produces a key unique to the given Words and parameters' do
      stream_a = PhonemeStream.new(@words, {})
      stream_b = PhonemeStream.new(@words, {})
      stream_c = PhonemeStream.new(@words, scalar: 2.0)
      stream_d = PhonemeStream.new(@words, scalar: 2.0)
      stream_a.key.must_equal '3e2a3015aa6d77f5593296ec955bdef3589b906ad44e7376418429a931d72c57'
      stream_a.key.must_equal stream_b.key
      stream_c.key.must_equal '3593b95a272da5edaf541a022fadbb186f437c7a767beb5a8d804ffa166742d9'
      stream_a.key.wont_equal stream_c.key
      stream_c.key.must_equal stream_d.key
    end
  end

  describe '#scaled' do
    it 'scales the phonemes given the specified scalar value' do
      stream_a = PhonemeStream.new(@words, scalar: 1)
      stream_b = PhonemeStream.new(@words, scalar: 1.66)
      stream_a.duration.must_equal 3.465666666666667
      stream_b.duration.must_equal 5.753006666666666
    end
  end
end
