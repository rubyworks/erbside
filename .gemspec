--- !ruby/object:Gem::Specification 
name: erbside
version: !ruby/object:Gem::Version 
  hash: 27
  prerelease: false
  segments: 
  - 0
  - 1
  - 0
  version: 0.1.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-04-24 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: facets
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :runtime
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: pom
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :runtime
  version_requirements: *id002
- !ruby/object:Gem::Dependency 
  name: ko
  prerelease: false
  requirement: &id003 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id003
description: Erbside is a simple project-oriented erb-based inline template system. Inline templates make it easy to do basic code generation without the need for duplicate files.
email: transfire@gmail.com
executables: 
- erbside
extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
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
- test/fixture/inline.rb
- test/fixture/inline_complex.rb
- test/inline_test.rb
- HISTORY.rdoc
- PROFILE
- LICENSE
- README.rdoc
- VERSION
has_rdoc: true
homepage: http://rubyworks.github.com/erbside
licenses: []

post_install_message: 
rdoc_options: 
- --title
- Erbside API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: erbside
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: ERB-based Inline Templating
test_files: 
- test/inline_test.rb
