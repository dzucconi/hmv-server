class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  register Sinatra::AssetPipeline

  get '/' do
    HTML.new.instance_eval do
      page do
        form(class: 'js-form') do
          textarea(
            class: 'js-input', placeholder: 'Begin typing, then <cmd> + <enter> to play', autofocus: 'true') { '' } +

          div(class: 'controls js-controls') do
            button(class: 'js-submit') { 'Play' }
          end
        end +

        div(class: 'progress') do
          div(class: 'progress-bar js-progress')
        end
      end
    end
  end

  get '/render.wav' do
    content_type 'audio/wav'

    raise Exception if params[:text].nil?

    words = Corrasable.new(params[:text]).to_phonemes
    output = Output.new(words, params[:type])

    File.open(output.filename).read
  end

  error Exception do
    status 400

    'Bad Request'
  end
end
