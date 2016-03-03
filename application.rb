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
    output.generate!
    File.open(output.filename).read
  end

  get '/render.json' do
    content_type 'text/json'
    output = Output.new params
    output.to_json
  end

  error Exception do
    status 400
    'Bad Request'
  end
end
