 # = base.rb - Define static value, utility-methods.
#
# Copyright:: Copyright (C) 2015
#             Kentarou Mamiya <kmamiya@logicalrabbit.jp>
# License::   The MIT License (MIT)
#

module FontParser
  class ParsedFont
    attr_reader(
      :font_path, # string
      :fonts,     # array of hash
      :ttc_header # hash
    )

    def initialize( font_path )
      @font_path = font_path
 
      read_font_file {|font_file|
        if ( ttc_file? font_file )
          @ttc_header = read_ttc_header( font_file  )
          @fonts = @ttc_header[:offset_tables].map do |offset_of_ttf|
            font_file.seek( offset_of_ttf, IO::SEEK_SET )
            read_ttf_header( font_file )
          end
        else
          font_file.seek( 0, IO::SEEK_SET )
          @fonts = [ read_ttf_header( font_file ) ]
        end
      }
    end

    include Base
    include Name

  private
    HEADER_TAG_SIZE    = 4
    TTC_HEADER_SIZE    = 
      FIXED_SIZE + # header_version
      ULONG_SIZE   # num_fonts
    TTC_HEADER_V2_SIZE = 
      ULONG_SIZE + # ulDsigTag
      ULONG_SIZE + # ulDsigLength
      ULONG_SIZE   # ulDsigOffset
    TTF_OFFSET_TABLE_SIZE =
      FIXED_SIZE  + # sfnt_verson
      USHORT_SIZE + # numTables
      USHORT_SIZE + # searchRange
      USHORT_SIZE + # entrySelector
      USHORT_SIZE   # rangeShift
    TTF_TABLE_RECORD_SIZE =
      ULONG_SIZE + # tag
      ULONG_SIZE + # checkSum
      ULONG_SIZE + # offset
      ULONG_SIZE   # length
  
    def ttc_file?(  font_file )
      ( 'ttcf' == font_file.read( HEADER_TAG_SIZE ) )? true: false
    end

    def ttc_header_v2?( header_version )
      ( '2.0' == header_version )? true: false
    end
  
    def read_ttc_header( font_file )
      header = font_file.read( TTC_HEADER_SIZE ).unpack( 'N2' )
      ttc_header = {
        :header_version => fixed_to_string( header[0] ),
        :num_fonts      => header[1],
        :offset_tables  => header[1].times.map {|dummy|
          font_file.read( ULONG_SIZE ).unpack( 'N' ).first
        }
      }
  
      if ttc_header_v2? ttc_header[:header_version]
        header_v2 = font_file.read( TTC_HEADER_V2_SIZE ).unpack( 'N3' )
        ttc_header[:d_sig_tag] = (( header_v2[0].nil? )?
          header_v2[0]:
          header_v2[0].to_s(16)
        )
        ttc_header[:d_sig_length] = header_v2[1]
        ttc_header[:d_sig_offset] = header_v2[2]
      end
  
      return ttc_header
    end
  
    def read_ttf_header( font_file )
      offset_table = font_file.read( TTF_OFFSET_TABLE_SIZE ).unpack( 'Nn4' )
      ttf_data = {
        :offset_table => {
          :sfnt_version   => fixed_to_string( offset_table[0] ),
          :num_tables     => offset_table[1],
          :search_range   => offset_table[2],
          :entry_selector => offset_table[3],
          :range_shift    => offset_table[4]
        },
        :table_records  => offset_table[1].times.map {|dummy|
          read_table_record( font_file )
        }
      }
      return ttf_data
    end
  
    def read_table_record( font_file )
      table_record = font_file.read( TTF_TABLE_RECORD_SIZE ).unpack( 'N4' )
      return {
        :tag       => [table_record[0].to_s(16)].pack( 'H8' ),
        :check_sum => table_record[1],
        :offset    => table_record[2],
        :length    => table_record[3]
      }
    end
  end
end
