class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js *.ico *png *.svg *.woff *.woff2)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  register Sinatra::AssetPipeline

  get '/' do
    Template::Index.page
  end

  get '/render.wav' do
    content_type 'audio/wav'

    output = Output.new params
    cached = Storage.get(output.filename)

    if cached
      cached.body
    else
      output.generate!
      io = File.open output.filename
      Storage.set io, output.filename
      io.read
    end
  end

  get '/render.json' do
    content_type 'text/json'
    output = Output.new params
    output.to_json
  end

  get '/phonemes' do
    content_type 'text/json'
    Corrasable.new(params[:text]).to_phonemes.to_json
  end

  error Exception do
    status 400
    'Bad Request'
  end
end
