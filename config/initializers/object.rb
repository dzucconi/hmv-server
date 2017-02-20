# frozen_string_literal: true
class Object
  def let
    yield self
  end
end
