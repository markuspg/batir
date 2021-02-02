# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

module Batir
  ##
  # Version information of Batir
  module Version
    ##
    # The major version of Batir
    MAJOR = 0
    ##
    # The minor version of Batir
    MINOR = 9
    ##
    # The tiny version of Batir
    TINY = 0
    ##
    # The full version of Batir as a String
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
