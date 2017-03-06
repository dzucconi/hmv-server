# frozen_string_literal: true
class User
  attr_accessor :username, :password, :authenticated

  def initialize(authenticated)
    @authenticated = authenticated
  end

  def authentic?
    @authenticated || (username == ENV['USERNAME'] && password == ENV['PASSWORD'])
  end
end
