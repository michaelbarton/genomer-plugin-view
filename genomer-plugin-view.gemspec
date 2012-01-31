# -*- encoding: utf-8 -*-
require File.expand_path("../lib/genomer-plugin-view/version", __FILE__)

Gem::Specification.new do |s|

  s.name        = "genomer-plugin-view"
  s.version     = GenomerViewPlugin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "http://github.com/michaelbarton/genomer-plugin-view"
  s.license     = "MIT"
  s.authors     = ["Michael Barton"]
  s.email       = ["mail@michaelbarton.me.uk"]
  s.summary     = %Q{Provide diferrent views of scaffold.}
  s.description = %Q{Convert genome scaffold into different sequence format views}

  s.required_rubygems_version = "~> 1.8.0"
  s.rubyforge_project         = "genomer-view-plugin"

  s.add_dependency "genomer", ">= 0.0.4"

  # Specs
  s.add_development_dependency "rspec",                   "~> 2.7.0"
  s.add_development_dependency "rr",                      "~> 1.0.0"
  s.add_development_dependency "scaffolder-test-helpers", "~> 0.4.0"
  s.add_development_dependency "heredoc_unindent",        "~> 1.1.0"

  # Features
  s.add_development_dependency "cucumber", "~> 1.0.0"
  s.add_development_dependency "aruba",    "~> 0.4.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
