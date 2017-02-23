# frozen_string_literal: true
class Corrasable
  attr_reader :text, :response

  ENDPOINT = 'https://api.corrasable.com/phonemes'

  class << self
    def cast(text, response)
      response
        .flatten(1) # Flatten outer array since we have no concept of lines
        .zip(Tokenizer.tokenize text)
        .map do |phonemes, word|
          # Cast the word/phonemes, include a pause
          [Word.new(word, phonemes), Word.new(' ', [' '])]
        end
        .flatten
    end
  end

  def initialize(text)
    @text = text
  end

  def request
    Typhoeus::Request.new(ENDPOINT,
      method: :post,
      params: {
        text: text
      }
    )
  end

  def get
    @response ||= Cached.get(CGI.escape request.url) do
      res = request.run
      res.success? ? res.body : raise(res.return_message)
    end

    Oj.load response
  end

  def to_words
    self.class.cast(text, get)
  end
end
