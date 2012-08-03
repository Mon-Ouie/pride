#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path(File.join("lib", File.dirname(__FILE__)))

require 'pride/version'

Gem::Specification.new do |s|
  s.name = "pride"

  s.version = Pride::Version

  s.summary = "Pry GUI"
  s.description = <<-eof
Seriously, just that: a Pry GUI.
eof

  s.homepage = "http://github.com/Mon-Ouie/pride"

  s.email   = "mon.ouie@gmail.com"
  s.authors = ["Mon ouie"]

  s.files |= Dir["lib/**/*.rb"]
  s.files |= Dir["test/**/*.rb"]
  s.files << "README.md"

  s.require_paths = %w[lib]

  s.add_dependency "pry", "~> 0.9.9"
  s.add_dependency "qtbindings", "~> 4.6"

  s.add_development_dependency "riot"

  s.executables = ["pride"]
end
