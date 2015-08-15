# font_parser
Parsing TTF/TTC font.

# Sample code

    require 'font_parser'
    
    ttf_font = FontParser::parse '/usr/share/fonts/ipa-mincho/ipam.ttf'
    ttf_name_table = ttf_font.name_table
    puts "  Format: #{ttf_name_table.format}"
    ttf_name_table.records.each {|record|
      puts "    Platform ID: #{record[:platform_id]}"
      puts "    Encoding ID: #{record[:encoding_id]}"
      puts "    Language ID: #{record[:language_id]}"
      puts "    Name_ID: #{record[:name_id]}"
      puts "    Value: #{record[:value]}"
    }
    
    
    ttc_font = FontParser::parse 'HGRPP1.TTC'
    puts "Font count  : #{ttc_font.fonts.size}"
    puts "Version     : #{ttc_font.ttc_header[:header_version]}"
    puts "Num fonts   : #{ttc_font.ttc_header[:num_fonts]}"
    puts "d_sig_tag   : #{ttc_font.ttc_header[:d_sig_tag]}"
    puts "d_sig_length: #{ttc_font.ttc_header[:d_sig_length]}"
    puts "d_sig_offset: #{ttc_font.ttc_header[:d_sig_offset]}"
    ttc_font.fonts.each_with_index {|font, i|
      puts "[#{i}]"
    
      ttc_name_table = ttc_font.name_table( i )
      puts "  Format: #{ttc_name_table.format}"
      ttc_name_table.records.each {|record|
        puts "    Platform ID: #{record[:platform_id]}"
        puts "    Encoding ID: #{record[:encoding_id]}"
        puts "    Language ID: #{record[:language_id]}"
        puts "    Name_ID: #{record[:name_id]}"
        puts "    Value: #{record[:value]}"
      }
    }

# Licence
Copyright (c) 2015 Kentarou Mamiya. See LICENSE for details.
