# Copyright (c) 2007-2012 Vassilis Rizopoulos. All rights reserved.
# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

require 'logger'

module Batir
  ##
  # Exception which is thrown by ShellCommand if the Hash used for
  # initialization misses the required +cmd+ key
  class ParameterException < RuntimeError
  end

  ##
  # Extend the default log message formatter to define an own format
  class BatirLoggerFormatter < Logger::Formatter
    ##
    # The format of the created log messages
    FORMAT = "[%s] %5s: %s\n"

    ##
    # Create a new instance defining the internally held log format
    def initialize
      super
      @datetime_format = '%Y%m%d %H:%M:%S'
    end

    ##
    # Create a formatted log message from the passed data
    def call(severity, time, _progname, msg)
      format(FORMAT, format_datetime(time), severity, msg2str(msg))
    end
  end

  ##
  # Set up a default logger for usage by top-level scripts and library users
  #
  # This creates a default logger fit for the usage with and around Batir.
  #
  # If no +filename+ is given output will be written to $stdout.
  #
  # +mode+ can be any value from Logger::Severity or
  # * +:mute+ to set the level to +FATAL+
  # * +:silent+ to set the level to +WARN+
  # * +:debug+ to set the level to +DEBUG+.
  #
  # +DEBUG+ is set as level also if $DEBUG is +true+ and overrides the +mode+
  # parameter in this case.
  #
  # The default log level is +INFO+ if no +mode+ is given.
  def self.setup_logger(filename = nil, mode = nil)
    logger = if filename
               Logger.new(filename)
             else
               Logger.new($stdout)
             end
    logger.level = Logger::INFO
    if [Logger::DEBUG, Logger::ERROR, Logger::FATAL, \
        Logger::INFO, Logger::UNKNOWN, Logger::WARN].member?(mode)
      logger.level = mode
    end
    logger.level = Logger::FATAL if mode == :mute
    logger.level = Logger::WARN if mode == :silent
    logger.level = Logger::DEBUG if mode == :debug || $DEBUG
    logger.formatter = BatirLoggerFormatter.new
    logger
  end
end
