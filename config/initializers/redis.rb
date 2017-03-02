# frozen_string_literal: true
$REDIS_CACHE = Redis.new(url: ENV['REDIS_CACHE_URL'])
$REDIS_PERSIST = Redis.new(url: ENV['REDIS_PERSIST_URL'])
