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
      " MAY 7 DEF Transfer - Acc\xC3\xA8sD / from 000000 PPP 12.34 567.89",
      " JUN 1 WWT Transfer - Acc\xC3\xA8sD - Internet / from 027674 PCA 1 234.56 7 890.98"
    ]
    no_matches = [
      " A1A B2B (123) 456-7890 Folio 12345 Page 1 of 2",
      # Add non-matches before this line to test without disabled processing
      " SAVINGS AND INVESTMENT ACCOUNT",
      " MAY 1 ABC Withdrawal / ABC YYZ 1.25 123.12 321.41",
      " MAY 7 DEF Transfer - Acc\xC3\xA8sD / from 000000 PPP 12.34 567.89",
      " JUN 1 WWT Transfer - Acc\xC3\xA8sD - Internet / from 027674 PCA 1 234.56 7 890.98"
    ]
    matches.each { |m| refute_nil matcher.match m }
    no_matches.each { |nm| assert_nil matcher.match nm }
  end
end
