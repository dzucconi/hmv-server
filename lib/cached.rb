# frozen_string_literal: true
class Cached
  class << self
    def get(key)
      cached = Storage.get key
      if cached
        cached.body
      else
        io = yield
        Storage.set io, key
        io.read
      end
    end
  end
end
