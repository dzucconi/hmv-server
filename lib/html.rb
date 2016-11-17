class HTML
  include Sprockets::Helpers

  def respond_to_missing?
    super
  end

  def method_missing(type, attributes = {})
    tag(type, attributes, block_given? ? yield.to_s : nil) || super
  end

  def tag(type, attributes, content)
    attributes.map do |k, v|
      "#{k}='#{v}'"
    end.join(' ').let do |attrs|
      " #{attrs}" unless attrs.empty?
    end.let do |attrs|
      content.nil? ? "<#{type}#{attrs}>" : "<#{type}#{attrs}>#{content}</#{type}>"
    end
  end
end
