# frozen_string_literal: true
class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js *.ico *png *.svg *.woff *.woff2)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  register Sinatra::AssetPipeline

  before do
    params.symbolize_keys!
  end

  get '/' do
    Template::Index.page
  end

  before %r{^/(render.*|phonemes)} do
    halt 400 unless params.ensure(:text)
    words = Corrasable.new(params[:text]).to_words
    @stream = PhonemeStream.new words, scalar: (params[:scalar] || 1).to_f
  end

  before %r{^/render.*} do
    synth = Synthetic.new params[:shape]&.to_sym
    @output = Output.new @stream, synth
  end

  get '/render.wav' do
    content_type 'audio/wav'
    Cached.get @output.filename do
      @output.generate!
      File.open @output.filename
    end
  end

  get '/render.json' do
    content_type 'text/json'
    @output.to_json
  end

  get '/phonemes' do
    content_type 'text/json'
    @stream.to_json
  end
end
