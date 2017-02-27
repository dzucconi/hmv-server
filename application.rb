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
    @synth = Synthetic.new params[:shape]&.to_sym, (params[:octave] || Synthetic::DEFAULT_OCTAVE).to_i
    @output = Output.new @stream, @synth
  end

  get '/render.wav' do
    content_type 'audio/wav'
    filename = "#{@output.filename}.wav"
    Storage.get filename do
      Wave.concat @output.buffers, Synthetic::SAMPLE_RATE, filename
      File.open filename
    end
  end

  get '/render.mp3' do
    content_type 'audio/mp3'
    Storage.get "#{@output.filename}.mp3" do
      Mp3.encode @output.buffers
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
