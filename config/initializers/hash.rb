class Hash
  def symbolize_keys
    self.reduce({}) do |memo, (k,v)|
      memo[k.to_sym] = v
      memo
    end
  end
end
