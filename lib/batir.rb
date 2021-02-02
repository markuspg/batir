# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

require_relative 'batir/version'

##
# This module contains the entire functionality of Batir.
#
# Some useful helpers are included as methods too.
#
# The main components of Batir are:
#
# * Command - module defining a basic interface for command objects
# * RubyCommand - class for treating a block of Ruby code as command
# * ShellCommand - class allowing to execute shell commands in a platform
#   independent fashion
# * CommandSequence - class for grouping and controlling sequences of Commands
# * Configurator - helper class for creating configuration files as Ruby code
module Batir
end
