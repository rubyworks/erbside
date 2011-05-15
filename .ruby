--- 
spec_version: 1.0.0
replaces: []

loadpath: 
- lib
name: erbside
repositories: 
  public: git://github.com/proutils/till.git
conflicts: []

engine_check: []

title: Erbside
contact: trans <transfire@gmail.com>
resources: 
  code: http://github.com/rubyworks/erbside
  talk: http://googlegroups.com/group/rubyworks-mailinglist
  docs: http://rubyworks.github.com/erbside/doc/api
  home: http://rubyworks.github.com/erbside
maintainers: []

requires: 
- group: []

  name: facets
  version: 0+
- group: []

  name: pom
  version: 0+
- group: 
  - test
  name: ko
  version: 0+
suite: rubyworks
manifest: MANIFEST
version: 0.1.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2010 Thomas Sawyer
authors: 
- Thomas Sawyer
description: Erbside is a simple project-oriented erb-based inline template system. Inline templates make it easy to do basic code generation without the need for duplicate files.
summary: ERB-based Inline Templating
created: 2009-07-15
