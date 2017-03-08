# frozen_string_literal: true
class Saved
  DB = $REDIS_PERSIST

  class << self
    def all
      DB.keys
    end

    def get(key)
      JSON.parse(DB.get(key)).symbolize_keys!
    end

    def set(key, value)
      DB.set(key, value.to_json.to_s)
      value.to_json
    end

    def delete(key)
      DB.del(key)
    end
  end
end
