#
# = base.rb - Define static value, utility-methods.
#
# Copyright:: Copyright (C) 2015
#             Kentarou Mamiya <kmamiya@logicalrabbit.jp>
# License::   The MIT License (MIT)
#

module FontParser
  module Base
    FIXED_SIZE  = 4
    ULONG_SIZE  = 4
    USHORT_SIZE = 2

    TTF_TABLE_RECORD_LENGTH =
      ULONG_SIZE + # tag
      ULONG_SIZE + # checkSum
      ULONG_SIZE + # offset
      ULONG_SIZE   # length

    def read_font_file
      open( @font_path, 'rb' ) {|reader| yield reader }
    end

    def fixed_to_string( fixed_value )
      "#{fixed_value >> 16}.#{fixed_value & 0x0000FFFF}"
    end

    def find_table( collection_index, tag )
      @fonts[collection_index][:table_records].each do |table_record|
        return table_record if tag == table_record[:tag]
      end
      return nil
    end
  end
end
