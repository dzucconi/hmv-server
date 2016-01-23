module Template
  class Index
    def self.page
      Layout.page do
        HTML.new.instance_eval do
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
  end
end
