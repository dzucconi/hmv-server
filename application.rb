# frozen_string_literal: true
class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js *.ico *png *.svg *.woff *.woff2)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  enable :sessions

  register Sinatra::AssetPipeline

  helpers do
    def logged_in?
      !!session[:authenticated]
    end

    def render(template, *data)
      Template::Layout.page do
        template.page(@user, *data)
      end
    end
  end

  before do
    params.symbolize_keys!
    @user = User.new session[:authenticated]
  end

  get '/' do
    render Template::Index
  end

  get '/login' do
    return redirect to('/') if logged_in?
    render Template::Login
  end

  get '/logout' do
    session[:authenticated] = false
    redirect to('/')
  end

  post '/login' do
    @user.username = params[:username]
    @user.password = params[:password]
    if @user.authentic?
      session[:authenticated] = true
      redirect to('/')
    else
      @user.password = nil
      redirect to('/login')
    end
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
    content_type 'application/json'

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
    @output = Output.new @stream, @synth
    filename = "#{@output.filename}.wav"
    Storage.get filename do
      Wave.concat @output.buffers, Synthetic::SAMPLE_RATE, filename
      File.open filename
    end
  end

  get '/render.mp3' do
    content_type 'audio/mp3'
    @output = Output.new @stream, @synth
    Storage.get "#{@output.filename}.mp3" do
      Mp3.encode @output.buffers
    end
  end

  get '/render.json' do
    content_type 'application/json'
    @output.to_json
  end

  get '/phonemes' do
    content_type 'application/json'
    @stream.to_json
  end

  get '/all' do
    render Template::All, Piece.all
  end

  post '/save' do
    return redirect '/' unless logged_in?
    content_type 'application/json'
    @piece = Piece.new(
      key: @output.key,
      input: params[:text],
      output: @output
    )
    @piece.save
    @piece.to_json
  end

  get '/:key' do
    content_type 'application/json'
    Piece.find(params[:key]).to_json
  end

  post '/delete' do
    return redirect '/' unless logged_in?
    Piece.delete(params[:key])
    200
  end
end
