require 'erbside/inline'

DIRECTORY = File.dirname(__FILE__)

KO.case Erbside::Inline do

  test 'inline rendering' do
    file = DIRECTORY + '/fixture/inline.rb'
    xs = Erbside::Inline.factory(file)
    es = xs.new(file)
    es.render
  end

end

