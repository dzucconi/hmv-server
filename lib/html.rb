class HTML
  include Sprockets::Helpers

  def method_missing(type, attributes = {})
    tag type, attributes, (block_given? ? yield.to_s : nil)
  end

  def tag(type, attributes, content)
    attributes.map { |k, v|
      "#{k}='#{v}'"
    }.join(' ').let { |attrs|
      " #{attrs}" unless attrs.empty?
    }.let { |attrs|
      content.nil? ? "<#{type}#{attrs}>" : "<#{type}#{attrs}>#{content}</#{type}>"
    }
  end
end
