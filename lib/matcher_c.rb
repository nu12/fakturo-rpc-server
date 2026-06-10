# frozen_string_literal: true

require 'date'
require_relative 'matcher'

class MatcherC < Matcher
  def initialize
    @re = /^\s*(?<month>\S{3,})\s(?<day>\d{1,2})\s(?<description>.*)\w{3}.*\s(?<value>\d+.\d{2})\s\d+.\d+/
    @month_matrix = {
      'JAN' => '01',
      'FEB' => '02',
      'MAR' => '03',
      'APR' => '04',
      'MAY' => '05',
      'JUN' => '06',
      'JUL' => '07',
      'AUG' => '08',
      'SEP' => '09',
      'OCT' => '10',
      'NOV' => '11',
      'DEC' => '12'
    }
  end

  def match(text)
    m = @re.match(text.force_encoding(Encoding::ISO_8859_1))
    
    p text if ENV.fetch('PRINT_LINE', 'false').downcase == "true"
    p m if ENV.fetch('PRINT_MATCH', 'false').downcase == "true"
    
    if is_valid? m
      return { date: "#{Date.today.year}-#{@month_matrix[m[:month]]}-#{m[:day]}",
               description: m[:description], value: m[:value].gsub(',', '.').to_f }
    end
    
    nil
  end

  private
  def is_valid?(match)
    return false unless match
    return false unless match[:day]
    return false unless match[:month]
    return false unless match[:description]
    return false unless match[:value]
    true
  end
end
