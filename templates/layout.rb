module Template
  class Layout
    def self.page
      HTML.new.instance_eval do
        '<!doctype html>' +
        html {
          head {
            meta(charset: 'utf-8') +
            meta('http-equiv' => 'X-UA-Compatible', content: 'IE=edge,chrome=1') +
            meta(name: 'viewport', content: 'width=device-width') +
            meta(name: 'apple-mobile-web-app-capable', content: 'yes') +
            meta(name: 'apple-mobile-web-app-status-bar-style', content: 'black') +

            title { 'HMV' } +

            link(rel: 'icon', href: image_path('favicon.ico')) +
            link(rel: 'stylesheet', type: 'text/css', href: stylesheet_path('application'))
          } +
          body {
            yield +
            script(src: javascript_path('application'), type: 'text/javascript') {}
          }
        }
      end
    end
  end
end
