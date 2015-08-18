# font_parser
Parsing TrueType Font (TTF) and TrueType Collection (TTC).

# Goal (temporary)
Parsing the TTC font file that is installed to MS-Windows, and get font-name from those.

# Install

    gem 'font_parser', :git => 'https://github.com/kmamiya/font_parser.git'

# Usage

    require 'font_parser'
    
## Parsing a TTF font
(IPA font of RPM installed on the CentOS.)

    ttf_font = FontParser::parse '/usr/share/fonts/ipa-mincho/ipam.ttf'
    ttf_name_table = ttf_font.name_table
    puts "  Format: #{ttf_name_table.format}"
    ttf_name_table.records.each do |record|
      puts "    Platform ID: #{record[:platform_id]}"
      puts "    Encoding ID: #{record[:encoding_id]}"
      puts "    Language ID: #{record[:language_id]}"
      puts "    Name_ID: #{record[:name_id]}"
      puts "    Value: #{record[:value]}"
    end
    
## Parsing a TTC font
(HG Soei Kaku poptai, the following code may be need to executing on the MS-Windows.)

    ttc_font = FontParser::parse 'HGRPP1.TTC'
    puts "Font count  : #{ttc_font.fonts.size}"
    puts "Version     : #{ttc_font.ttc_header[:header_version]}"
    puts "Num fonts   : #{ttc_font.ttc_header[:num_fonts]}"
    puts "d_sig_tag   : #{ttc_font.ttc_header[:d_sig_tag]}"
    puts "d_sig_length: #{ttc_font.ttc_header[:d_sig_length]}"
    puts "d_sig_offset: #{ttc_font.ttc_header[:d_sig_offset]}"
    ttc_font.fonts.each_with_index do |font, i|
      puts "[#{i}]"
    
      ttc_name_table = ttc_font.name_table( i )
      puts "  Format: #{ttc_name_table.format}"
      ttc_name_table.records.each do |record|
        puts "    Platform ID: #{record[:platform_id]}"
        puts "    Encoding ID: #{record[:encoding_id]}"
        puts "    Language ID: #{record[:language_id]}"
        puts "    Name_ID: #{record[:name_id]}"
        puts "    Value: #{record[:value]}"
      end
    end

# Website (Japanese)

http://logicalrabbit.jp/font_parser

# Licence
Copyright (c) 2015 Kentarou Mamiya. See LICENSE for details.
