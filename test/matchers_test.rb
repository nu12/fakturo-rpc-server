require 'minitest/autorun'

require_relative '../lib/matcher_a'
require_relative '../lib/matcher_b'
require_relative '../lib/matcher_c'

class TestMatchers < Minitest::Test
  def test_matcher_a
    matcher = MatcherA.new
    matches = [
      '01 06 02 06 ABC 0.5% 34.48'
    ]
    no_matches = []
    matches.each { |m| refute_nil matcher.match m }
    no_matches.each { |nm| assert_nil matcher.match nm }
  end

  def test_matcher_b
    matcher = MatcherB.new
    matches = [
      " ao\xC3\xBB 29 sep 02 ABC 18,95"
    ]
    no_matches = [
      " Total 11 121,35 23 1 335,51"
    ]
    matches.each { |m| refute_nil matcher.match m }
    no_matches.each { |nm| assert_nil matcher.match nm }
  end

  def test_matcher_c
    matcher = MatcherC.new
    matches = [
      " MAY 1 ABC Withdrawal / ABC YYZ 1.25 123.12 321.41",
      " MAY 7 DEF Transfer - Acc\xC3\xA8sD / from 000000 PPP 12.34 567.89"
    ]
    no_matches = []
    matches.each { |m| refute_nil matcher.match m }
    no_matches.each { |nm| assert_nil matcher.match nm }
  end
end
