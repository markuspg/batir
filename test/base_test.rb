# Copyright (c) 2007-2012 Vassilis Rizopoulos. All rights reserved.
# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'batir/base'

module Batir::Test
  ##
  # Check the functionality of the Batir module
  class Module < Minitest::Test
    ##
    # A temporary log file for testing
    TEMP_LOG = 'temp.log'

    ##
    # Clean-up steps after each of the test cases for the Batir module
    def teardown
      File.delete(TEMP_LOG) if File.exist?(TEMP_LOG)
    end

    ##
    # Verify that the default logger setup works correctly
    def test_setup_logger_default
      logger = Batir.setup_logger
      assert_equal(Logger::INFO, logger.level)
      assert_instance_of(Batir::BatirLoggerFormatter, logger.formatter)
      out, = capture_subprocess_io do
        logger.debug('Test')
        logger.warn('Oh oh')
      end
      assert_match(/\[\d{8} \d\d:\d\d:\d\d\]  WARN: Oh oh\n/, out)
    end

    ##
    # Verify that Batir.setup_logger logs to the correct file
    def test_setup_logger_file
      logger = Batir.setup_logger(TEMP_LOG, nil)
      logger.close
      assert(File.exist?(TEMP_LOG))
    end

    ##
    # Verify that Batir.setup_logger correctly handles mode parameters
    def test_setup_logger_mode
      [[:debug, [Logger::DEBUG], 'DEBUG'],
       [:mute, [Logger::DEBUG, Logger::WARN, Logger::FATAL], 'FATAL'],
       [:silent, [Logger::INFO, Logger::WARN], ' WARN']].each do |data|
         logger = Batir.setup_logger(nil, data[0])
         out, = capture_subprocess_io do
           data[1].each do |severity|
             logger.log(severity, 'Test Message')
           end
         end
         match = /\[\d{8} \d\d:\d\d:\d\d\] (DEBUG|FATAL| WARN): Test Message\n/.match(out)
         refute_nil(match)
         assert_equal(data[2], match[1])
       end
    end
  end
end
