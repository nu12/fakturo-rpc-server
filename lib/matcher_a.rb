require_relative "matcher"

class MatcherA < Matcher
  def initialize
    @re = /(?<day>\d{2})\W(?<month>\d{2})\W\d{2}\W\d{2}\W(?<description>[\w' ]+).+\D(?<value>\d+.\d{2}|\d+.\d{2}CR)\s*$/
  end

  def match text
    m = @re.match(text)
    return {date: "#{Date.today.year}-#{m[:month]}-#{m[:day]}", description: m[:description], value: m[:value].to_f} if m && m[:day] && m[:month] && m[:description] && m[:value]
    return nil
  end
end