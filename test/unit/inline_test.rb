require 'erbside/inline'

testcase Erbside::Ruby do

  test '' do

    es = Erbside::Inline.new(DIR + 'fixture/inline.rb')
    es.render
    end

  end

end

