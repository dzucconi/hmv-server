class Cached
  class << self
    def get(key, &block)
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
