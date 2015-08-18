# coding: utf-8

lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'font_parser'

Gem::Specification.new do |spec|
  spec.name        = 'font_parser'
  spec.version     = FontParser::VERSION
  spec.date        = '2015-08-18'
  spec.summary     = %q{Parsing TrueType Font (TTF) and TrueType Collection (TTC).}
  spec.description = %q{The parser for TTF/TTC font file. Use to get the font-information.}
  spec.license     = 'MIT'
  spec.authors     = 'Kentarou Mamiya'
  spec.email       = 'kmamiya@logicalrabbit.jp'
  spec.homepage    = 'http://logicalrabbit.jp/font-parser'
  spec.files       = [
    '.gitignore',
    'LICENSE',
    'README.md',
    'lib/font_parser.rb',
    'lib/font_parser/base.rb',
    'lib/font_parser/parsed_font.rb',
    'lib/font_parser/ttf/name.rb'
  ]
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new( '>= 1.9' )
end
