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

  before %r{^/(render.*|phonemes|save)} do
    halt 400 unless params.ensure(:text)
    words = Corrasable.new(params[:text]).to_words
    options = { scalar: (params[:scalar] || 1).to_f }
    options[:pause] = params[:pause].to_f if params.key?(:pause)
    @stream = PhonemeStream.new words, options
  end

  before %r{^/(render.*|save)} do
    synth = Synthetic.new params[:shape]&.to_sym, (params[:octave] || Synthetic::DEFAULT_OCTAVE).to_i
    @output = Output.new @stream, synth
  end

  get '/rendered.json' do
    content_type 'text/json'

    url = Storage.url @output.filename do
      @output.generate!
      File.open @output.filename
    end

    {
      url: url,
      output: @output
    }.to_json
  end

  get '/render.wav' do
    content_type 'audio/wav'
    Storage.get @output.filename do
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

  get '/all' do
    @pieces = Piece.all
    Template::All.page @pieces
  end

  post '/save' do
    content_type 'text/json'
    @piece = Piece.new(
      key: @output.key,
      input: params[:text],
      output: @output
    )
    @piece.save
    @piece.to_json
  end

  get '/:key' do
    content_type 'text/json'
    Piece.find(params[:key]).to_json
  end

  post '/delete' do
    Piece.delete(params[:key])
    200
  end
end
