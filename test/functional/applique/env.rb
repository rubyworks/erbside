#require 'tmpdir'
require 'erbside'

When "Given a file named '(((.*?)))'" do |name, text|
  File.open(name, 'w+'){ |f| f << text }
end

When "Rendering via the commandline" do |text|
  #@result = Erbside.cli('-o', 'example.rb')
  text.sub!(/^\$\s*/, '')
  @result = `#{text}`
end

When "result will be" do |text|
  text.strip.assert == @result.strip
end

When "The rendered result of '(((.*?)))' will be" do |file, text|
  result = ""
  runner  = Erbside::Runner.new([file], :output=>result)
  runner.render

  text.strip.assert == result.strip
end


#    out = File.join(@tmpdir, "fixture/inline.rb")
#    system "till -f #{out}"
#    expect = File.read('test/features/proofs/inline.rb')
#  result = File.read(out)
#
#   assert_equal(expect, result)

