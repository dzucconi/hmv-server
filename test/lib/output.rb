require File.expand_path '../../helper.rb', __FILE__

PHONEME_STREAM = [
  %w(HH AH0 L OW1), # HELLO
  %w(W ER1 L D) # WORLD
].freeze

describe 'Output' do
  describe '#stream' do
    it 'converts the phonemes to a flat stream of unscaled utterances' do
      Output.new(words: PHONEME_STREAM)
        .stream.must_equal [
          { phoneme: :hh, duration: 0.057 },
          { phoneme: :ah, duration: 0.10933333333333334 },
          { phoneme: :l, duration: 0.10933333333333334 },
          { phoneme: :ow, duration: 0.139 },
          { phoneme: :pause, duration: 0.3 },
          { phoneme: :w, duration: 0.11 },
          { phoneme: :er, duration: 0.14 },
          { phoneme: :l, duration: 0.10933333333333334 },
          { phoneme: :d, duration: 0.025 }
        ]
    end
  end

  describe '#scaled' do
    it 'converts the phonemes to a flat stream of utterancess with relatively sacled durations ' do
      skip 'output deviation'
      Output.new(words: PHONEME_STREAM, duration: 5)
        .scaled.must_equal [
          { phoneme: :hh, duration: 0.31701890989988873 },
          { phoneme: :ah, duration: 0.6080830552465701 },
          { phoneme: :l, duration: 0.6080830552465701 },
          { phoneme: :ow, duration: 0.7730812013348164 },
          { phoneme: :pause, duration: 0.5561735261401556 },
          { phoneme: :w, duration: 0.6117908787541712 },
          { phoneme: :er, duration: 0.778642936596218 },
          { phoneme: :l, duration: 0.6080830552465701 },
          { phoneme: :d, duration: 0.1390433815350389 }
        ]
    end

    it 'has durations that add up to the target duration' do
      Output.new(words: PHONEME_STREAM, duration: 5)
        .scaled.map { |x| x[:duration] }.reduce(:+)
        .must_equal 5.0
    end
  end

  describe '#to_json' do
    it 'outputs a set of words with start/stop times' do
      skip 'output deviation'
      Output.new(text: 'hello world', words: PHONEME_STREAM, duration: 5)
        .to_json.must_equal %{[{"word":"hello","duration":2.3062662217278453},{"word":" ","duration":0.5561735261401556},{"word":"world","duration":2.137560252131998}]}
    end
  end
end
