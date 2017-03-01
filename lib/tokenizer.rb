# frozen_string_literal: true
class Tokenizer
  WHITESPACE = Regexp.new('[[:blank:]]+')

  class << self
    def tokenize(input)
      input.chomp.strip.split(WHITESPACE)
    end
  end
end
