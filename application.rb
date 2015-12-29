class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  register Sinatra::AssetPipeline

  get '/' do
    HTML.new.instance_eval do
      page do
        div(id: 'progress', class: 'progress') do
          div(id: 'progress-bar', class: 'progress-bar')
        end +

        form do
          textarea(id: 'input', placeholder: 'Begin typing, then <cmd> + <enter> to play', autofocus: 'true') { '' } +

          div(id: 'controls', class: 'l-controls controls') do
            button(id: 'submit') { 'Play' }
          end
        end +

        audio do
          source(id: 'source', type: 'audio/wav')
        end
      end
    end
  end

  get '/render' do
    content_type 'audio/wav'

    raise Exception if params[:text].nil?

    words = Corrasable.new(params[:text]).to_phonemes
    output = Output.new(words)

    File.open(output.filename).read
  end

  error Exception do
    status 400

    'Bad Request'
  end
end
