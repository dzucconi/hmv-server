# frozen_string_literal: true
class Hash
  def symbolize_keys
    self.reduce({}) do |memo, (k, v)|
      memo[k.to_sym] = v
      memo
    end
  end

  def symbolize_keys!
    keys.each do |key|
      self[key.to_sym] = delete(key)
    end

    self
  end

  def pick(*keys)
    self.select do |key, _|
      keys.include?(key)
    end
  end

  def ensure(*keys)
    keys.all? { |key| self.key? key }
  end
end
