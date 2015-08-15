# = font_parser.rb
# 
# Copyright:: Copyright (C) 2015
#             Kentarou Mamiya <kmamiya@logicalrabbit.jp>
# License::   The MIT License (MIT)
#

module FontParser
  autoload :ParsedFont, 'font_parser/parsed_font'
  autoload :Base,       'font_parser/base'
  autoload :Name,       'font_parser/ttf/name'

  def self.parse( font_path )
    ParsedFont.new( font_path )
  end
end
