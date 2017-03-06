class Converter
  TRANSCODER = Aws::ElasticTranscoder::Client.new(region: ENV['AWS_REGION']).freeze
  PIPELINE_ID = ENV['AWS_ET_PIPELINE_ID'].freeze
  AWS_ET_PRESET_ID = ENV['AWS_ET_PRESET_ID'].freeze

  class << self
    def convert(key)
      TRANSCODER.create_job(
        pipeline_id: PIPELINE_ID,
        input: {
          key: "tmp/#{key}.wav",
        },
        outputs: [{
          key: "mp3/#{key}.mp3",
          preset_id: PRESET_ID
        }]
      )
    end
  end
end
