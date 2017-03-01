# frozen_string_literal: true
class Corrasable
  attr_reader :text, :response

  ENDPOINT = 'https://api.corrasable.com/words/bulk'

  class << self
    def cast(response)
      response['words'].map do |word|
        # Cast the word/phonemes, include a pause
        [Word.new(word['word'], word['phonemes']), Word.new(' ', [' '])]
      end.flatten
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
    @response ||= Cached.get(CGI.escape(request.url)) do
      res = request.run
      res.success? ? res.body : raise(res.return_message)
    end

    Oj.load response
  end

  def to_words
    self.class.cast(get)
  end
end
