class Hash
  def symbolize_keys
    self.each_with_object({}) do |memo, (k, v)|
      memo[k.to_sym] = v
    end
  end
end
