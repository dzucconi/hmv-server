# frozen_string_literal: true
$REDIS_CACHE = Redis.new(url: "#{ENV['REDIS_URL']}/0")
$REDIS_PERSIST = Redis.new(url: "#{ENV['REDIS_URL']}/1")
