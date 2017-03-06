module Template
  class Index
    def self.page(user)
      HTML.new.instance_eval do
        form(class: 'js-form') do
          textarea(
            class: 'js-input', placeholder: 'Begin typing, then <cmd> + <enter> to play', autofocus: 'true') { '' } +

          div(class: 'controls js-controls') do
            button(class: 'js-submit') { 'Play' } +
            (user.authentic? ? a(class: 'js-save') { 'Save' } : a(href: '/login') { 'Login' })
          end
        end +

        div(class: 'progress') do
          div(class: 'progress-bar js-progress')
        end
      end
    end
  end
end
