class Corrasable
  attr_reader :text

  def initialize(text)
    @text = self.class.sanitize(text)
  end

  def to_phonemes
    Typhoeus::Request.new('api.corrasable.com/phonemes',
      method: :post,
      params: {
        text: text
      }
    ).run.let do |response|
      Oj.load(response.body)
        .flatten(1) # Flatten outer array since we have no concept of lines
        .map { |word| word.split(' ') } # Split each word into an array of phonemes
        .reject { |word| word == ['N/A'] } # Remove any words with failed transcriptions
    end
  end

  def self.sanitize(string)
    string
      .gsub(/[^a-z ]/i, '') # Avoid punctuation and numbers for the time being
  end
end
