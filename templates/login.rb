module Template
  class Login
    def self.page(_ = nil)
      HTML.new.instance_eval do
        form(action: '/login', method: 'POST') do
          input(type: 'text', name: 'username') +
          input(type: 'password', name: 'password') +
          div(class: 'controls') do
            button { 'Login' }
          end
        end
      end
    end
  end
end
