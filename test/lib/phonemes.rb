require File.expand_path '../../helper.rb', __FILE__

describe 'Phonemes' do
  describe '#duration' do
    it '#duration' do
      [
        "HH: #{Phonemes.duration :HH} #{Phonemes.duration_legacy :HH}",
        "EH: #{Phonemes.duration :EH} #{Phonemes.duration_legacy :EH}",
        "L: #{Phonemes.duration :L} #{Phonemes.duration_legacy :L}",
        "P: #{Phonemes.duration :P} #{Phonemes.duration_legacy :P}"
      ].must_equal [
        "HH: 0.057 0.05847953216374269",
        "EH: 0.06433333333333334 0.05181347150259067",
        "L: 0.10933333333333334 0.03048780487804878",
        "P: 0.03133333333333333 0.10638297872340426"
      ]
    end
  end
end
