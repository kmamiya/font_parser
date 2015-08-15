# = name.rb - Reader for the Name-table in TTF-font.
# 
# Copyright:: Copyright (C) 2015
#             Kentarou Mamiya <kmamiya@logicalrabbit.jp>
# License::   The MIT License (MIT)
#

require 'stringio'

module FontParser
  module Name
    def name_table( collection_num = 0 )
      table_record = find_table( collection_num, 'name' )
      if table_record.nil?
        return nil
      else
        read_font_file {|font_file|
          return NameObj.new( font_file, table_record )
        }
      end
    end

  class NameObj
    include Base

    attr_accessor :format, :string_offset, :records

    NAME_TABLE_SIZE =
      USHORT_SIZE + # format
      USHORT_SIZE + # count
      USHORT_SIZE   # stringOffset
    NAME_RECORD_SIZE =
      USHORT_SIZE + # platformID
      USHORT_SIZE + # encodingID
      USHORT_SIZE + # languageID
      USHORT_SIZE + # nameID
      USHORT_SIZE + # length
      USHORT_SIZE   # offset

    def initialize( font_file, table_record )
      font_file.seek( table_record[:offset], IO::SEEK_SET )
      name_table = font_file.read( NAME_TABLE_SIZE ).unpack( 'n3' )
      @format        = name_table[0]
      record_count   = name_table[1]
      @string_offset = name_table[2]

      @records = record_count.times.map {|dummy|
        name_record = font_file.read( NAME_RECORD_SIZE ).unpack( 'n6' )
        {
          :platform_id => (case name_record[0]
            when 0 then :unicode
            when 1 then :macintosh
            when 2 then :iso
            when 3 then :windows
            when 4 then :constom
            else :costom
          end),
          :encoding_id => name_record[1],
          :language_id => name_record[2],
          :name_id     => name_record[3],
          :length      => name_record[4],
          :offset      => name_record[5]
        }
      }
  
      #TODO LangTagRecord
  
      font_file.seek( table_record[:offset] + @string_offset, IO::SEEK_SET )

      @records.each do |record|
        value = font_file.read( record[:length] ).unpack( 'H*' ).first
        if :windows == record[:platform_id]
          record[:language_id] = record[:language_id].to_s( 16 )
          record[:value] = case record[:encoding_id]
            # TODO when 0
            when 1
              unicode_encoding( value )
            # TODO when 2, 3, 4, 5, 6, 7, 8, 9
            when 10
              unicode_encoding( value )
            else value
          end
        else
          record[:value] = value
        end
      end
    end 

  private
    def unicode_encoding( value )
      value.scan( /..../ ).map {|code| [code.hex].pack( 'U' )}.join( '' )
    end

  end
end
end
