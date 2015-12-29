require File.expand_path '../../helper.rb', __FILE__

describe 'HTML' do
  it 'returns a tag' do
    HTML.new.div(id: 'foo') { 'bar' }.must_equal("<div id='foo'>bar</div>")
  end

  it 'returns an HTML fragment' do
    HTML.new.instance_eval {
      div(id: 'foo') {
        div(id: 'bar') {
          'baz'
        }
      }
    }.must_equal("<div id='foo'><div id='bar'>baz</div></div>")
  end
end
