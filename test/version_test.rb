# Copyright (c) 2007-2012 Vassilis Rizopoulos. All rights reserved.
# Copyright (c) 2021 Markus Prasser. All rights reserved.

# frozen_string_literal: true

require 'test_helper'

module Batir
  ##
  # Module for the verification of the functionality of Batir
  module Test
    ##
    # Check Batir::Version
    class Version < Minitest::Test
      ##
      # Verify that the version data is correctly set
      def test_version_data
        assert_equal(1, ::Batir::Version::MAJOR)
        assert_equal(0, ::Batir::Version::MINOR)
        assert_equal(0, ::Batir::Version::PATCH)
        assert_equal('1.0.0', ::Batir::Version::STRING)
      end
    end
  end
end
