# frozen_string_literal: true
class Cached
  class << self
    def get(key)
      cached = $REDIS.get key
      if cached.nil?
        value = yield.to_s
        $REDIS.set key, value
        value
      else
        cached
      end
    rescue
      yield.to_s
    end
  end
end
