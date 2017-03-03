module Template
  class All
    def self.page(all)
      Layout.page do
        HTML.new.instance_eval do
          div(class: 'all') do
            all.map do |key|
              div(class: 'saved') do
                a(href: "/#{key}") { key } + ' ' +
                a(class: 'delete js-delete', 'data-key' => key) { 'Delete' }
              end
            end.join('')
          end
        end
      end
    end
  end
end
