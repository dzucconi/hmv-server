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

    def qualified(key)
      "https://#{BUCKET}.s3.amazonaws.com/#{key}"
    end

    def get(key)
      cached = __get__(key)
      if cached
        cached.body
      else
        io = yield
        set(io, key)
        io.read
      end
    end

    def url(key)
      cached = __get__(key)
      obj = if cached
              cached
            else
              io = yield
              set(io, key)
      end
      obj.public_url
    end

    def __get__(key)
      bucket.files.get(key)
    end

    def set(io, key)
      object = bucket.files.create(
        key: key,
        public: true,
        body: io.read
      )

      io.rewind

      object
    end

    def delete(key)
      get(key).destroy
    end
  end
end
