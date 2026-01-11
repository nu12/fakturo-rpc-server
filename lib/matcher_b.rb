# frozen_string_literal: true

require 'date'
require_relative 'matcher'

class MatcherB < Matcher
  def initialize
    @re = /^\s*(?<month>\S{3,})\s(?<day>\d{2})\s+\S{3,}\s\d{2}[\s\W]+(?<description>[\w' ]+).*\D(?<value>\d+,\d{2})/
    @month_matrix = {
      'jan' => '01',
      'fév' => '02',
      'mar' => '03',
      'avr' => '04',
      'mai' => '05',
      'jun' => '06',
      'jlt' => '07',
      'aoû' => '08',
      'sep' => '09',
      'oct' => '10',
      'nov' => '11',
      'déc' => '12'
    }
  end

  def match(text)
    m = @re.match(text.force_encoding(Encoding::ISO_8859_1))
    if m && m[:day] && m[:month] && m[:description] && m[:value]
      return { date: "#{Date.today.year}-#{@month_matrix[m[:month].force_encoding(Encoding::UTF_8)]}-#{m[:day]}",
               description: m[:description], value: m[:value].gsub(',', '.').to_f }
    end

    nil
  end
end
