== Ruby

Given a file named 'example.rb' containing:

  # Stuff
  puts "Testing...."

  #:erb+1: <%= %w{z y x}.sort.join("\n") %>
  blah blah blah

  # Manifest generated 2009  #:erb: ^generated <%= 2009 %>

  # Some comment
  puts "We are at the end."

  VERSION = "2" # :erb: VERSION = "<%= 1+1 %>"

  # Another comment
  puts "Yes we are."

We can render 'example.rb' to a string with the following code.

  @result = ""
  runner  = Erbside::Runner.new(['example.rb'], :output=>@result)
  runner.render

The result will be:

  # Stuff
  puts "Testing...."

  #:erb+3: <%= %w{z y x}.sort.join("\n") %>
  x
  y
  z

  # Manifest generated 2009  #:erb: ^generated <%= 2009 %>

  # Some comment
  puts "We are at the end."

  VERSION = "2" # :erb: VERSION = "<%= 1+1 %>"

  # Another comment
  puts "Yes we are."

