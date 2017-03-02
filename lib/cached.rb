# frozen_string_literal: true
class Cached
  DB = $REDIS_CACHE

  class << self
    def get(key, replace = false)
      cached = DB.get key
      if replace || cached.nil?
        value = yield.to_s
        DB.set key, value
        value
      else
        cached
      end
    rescue
      yield.to_s
    end

    def purge
      DB.flushdb
    end

    def keys
      DB.keys
    end
  end
end
