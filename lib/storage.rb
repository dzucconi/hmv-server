# frozen_string_literal: true
module Storage
  BUCKET = ENV['S3_BUCKET']

  class << self
    def connection
      @connection ||= Fog::Storage.new(
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        provider: 'AWS'
      )
    end

    def bucket
      @bucket ||= connection.directories.get(BUCKET)
    end

    def get(key)
      bucket.files.get(key)
    end

    def set(io, key)
      object = bucket.files.create(
        key: key,
        public: true,
        body: io.read
      )

      io.rewind

      [io, object]
    end

    def delete(key)
      get(key).destroy
    end
  end
end
