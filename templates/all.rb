module Template
  class All
    def self.page(_user, pieces)
      HTML.new.instance_eval do
        div(class: 'pieces') do
          pieces.map do |piece|
            div(class: 'piece') do
              a(href: "/#{piece.key}") { piece.input } + ' ' +
              a(class: 'delete js-delete', 'data-key' => piece.key) { 'Delete' }
            end
          end.join('')
        end
      end
    end
  end
end
