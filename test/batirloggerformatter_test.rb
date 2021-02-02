# Copyright (c) 2007-2012 Vassilis Rizopoulos. All rights reserved.
# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'batir/base'

module Batir::Test
  ##
  # Check Batir::BatirLoggerFormatter
  class BatirLoggerFormatter < Minitest::Test
    ##
    # Verify that Batir::BatirLoggerFormatter#call correctly formats messages
    def test_call
      formatter = Batir::BatirLoggerFormatter.new
      time = Time.new(2021, 1, 19, 21, 59, 14)
      assert_equal("[20210119 21:59:14]     1: Ouch\n",
                   formatter.call(Logger::INFO, time, 'test_prog', 'Ouch'))
      time = Time.new(2021, 1, 19, 22, 4, 11)
      assert_equal("[20210119 22:04:11]     2: Oh oh\n",
                   formatter.call(Logger::WARN, time, 'test_prog', 'Oh oh'))
    end

    ##
    # Verify that Batir::BatirLoggerFormatter is being initialized correctly
    def test_initialization
      formatter = Batir::BatirLoggerFormatter.new
      assert_equal('%Y%m%d %H:%M:%S', formatter.datetime_format)
    end
  end
end
