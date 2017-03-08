# frozen_string_literal: true
class Transcoder
  TRANSCODER = Aws::ElasticTranscoder::Client.new(region: ENV['AWS_REGION']).freeze
  PIPELINE_ID = ENV['AWS_ET_PIPELINE_ID'].freeze
  PRESET_ID = ENV['AWS_ET_PRESET_ID'].freeze

  class << self
    def url(key)
      Storage.qualified(path(key))
    end

    def path(key)
      "mp3/#{key}.mp3"
    end

    def convert(key)
      TRANSCODER.create_job(
        pipeline_id: PIPELINE_ID,
        input: {
          key: "tmp/#{key}.wav"
        },
        outputs: [{
          key: path(key),
          preset_id: PRESET_ID
        }]
      )

      url(key)
    end
  end
end
