== Commandline Interface

Given a file named 'example.rb' containing:

  example # :erb: change <%= 1+1 %>

Rendering via the commandline:

  $ erbside -o foo.rb

The result will be:

  change 2 # :erb: change <%= 1+1 %>

