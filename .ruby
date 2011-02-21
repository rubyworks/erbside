--- 
name: erbside
spec_version: 1.0.0
repositories: 
  public: git://github.com/proutils/till.git
title: Erbside
contact: trans <transfire@gmail.com>
requires: 
- group: []

  name: facets
  version: 0+
resources: 
  code: http://github.com/rubyworks/erbside
  home: http://rubyworks.github.com/erbside
suite: rubyworks
manifest: 
- bin/erbside
- lib/erbside/context.rb
- lib/erbside/inline/bash.rb
- lib/erbside/inline/cpp.rb
- lib/erbside/inline/css.rb
- lib/erbside/inline/js.rb
- lib/erbside/inline/ruby.rb
- lib/erbside/inline/sgml.rb
- lib/erbside/inline.rb
- lib/erbside/metadata.rb
- lib/erbside/runner.rb
- lib/erbside.rb
- lib/plugins/syckle/erbside.rb
- test/functional/applique/env.rb
- test/functional/bash.rdoc
- test/functional/cli.rdoc
- test/functional/cpp.rdoc
- test/functional/css.rdoc
- test/functional/javascript.rdoc
- test/functional/ruby.rdoc
- test/functional/sgml.rdoc
- test/unit/fixture/inline.rb
- test/unit/fixture/inline_complex.rb
- test/unit/inline_test.rb
- PROFILE
- LICENSE
- README
- HISTORY
- VERSION
version: 0.1.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2010 Thomas Sawyer
description: Erbside is a simple project-oriented erb-based inline template system. Inline templates make it easy to do basic code generation without the need for duplicate files.
summary: ERB-based Inline Templating
authors: 
- Thomas Sawyer
created: 2009-07-15
