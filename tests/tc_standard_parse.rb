# -----------------------------------------------------------------------------
# 
# Versionomy parsing tests on standard schema
# 
# This file contains tests for parsing on the standard schema
# 
# -----------------------------------------------------------------------------
# Copyright 2008-2009 Daniel Azuma
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# -----------------------------------------------------------------------------


require 'test/unit'
require File.expand_path("#{File.dirname(__FILE__)}/../lib/versionomy.rb")


module Versionomy
  module Tests  # :nodoc:
    
    class TestStandardParse < Test::Unit::TestCase  # :nodoc:
      
      
      # Test parsing full.
      
      def test_parsing_full_release
        value_ = Versionomy.parse('2.0.1.1-4.6')
        assert_equal(2, value_.major)
        assert_equal(0, value_.minor)
        assert_equal(1, value_.tiny)
        assert_equal(1, value_.tiny2)
        assert_equal(:final, value_.release_type)
        assert_equal(4, value_.patchlevel)
        assert_equal(6, value_.patchlevel_minor)
        assert_equal('2.0.1.1-4.6', value_.unparse)
      end
      
      
      # Test parsing abbreviated.
      
      def test_parsing_abbrev_release
        value_ = Versionomy.parse('2.0.1')
        assert_equal(2, value_.major)
        assert_equal(0, value_.minor)
        assert_equal(1, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:final, value_.release_type)
        assert_equal(0, value_.patchlevel)
        assert_equal(0, value_.patchlevel_minor)
        assert_equal('2.0.1.0-0.0', value_.unparse(:required_fields => [:minor, :tiny, :tiny2, :patchlevel, :patchlevel_minor]))
        assert_equal('2.0.1-0', value_.unparse(:required_fields => [:minor, :patchlevel]))
        assert_equal('2.0.1', value_.unparse)
      end
      
      
      # Test parsing with trailing zeros.
      
      def test_parsing_trailing_zeros
        value_ = Versionomy.parse('2.0.0')
        assert_equal(2, value_.major)
        assert_equal(0, value_.minor)
        assert_equal(0, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:final, value_.release_type)
        assert_equal(0, value_.patchlevel)
        assert_equal(0, value_.patchlevel_minor)
        assert_equal('2.0.0', value_.unparse)
      end
      
      
      # Test parsing preview.
      
      def test_parsing_preview
        value_ = Versionomy.parse('2.0.1pre4')
        assert_equal(2, value_.major)
        assert_equal(0, value_.minor)
        assert_equal(1, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:preview, value_.release_type)
        assert_equal(4, value_.preview_version)
        assert_equal(0, value_.preview_minor)
        assert_equal('2.0.1pre4', value_.unparse)
        assert_equal('2.0.1pre4.0', value_.unparse(:required_fields => [:preview_minor]))
      end
      
      
      # Test parsing alpha.
      
      def test_parsing_alpha
        value_ = Versionomy.parse('2.0.1a4.1')
        assert_equal(2, value_.major)
        assert_equal(0, value_.minor)
        assert_equal(1, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:alpha, value_.release_type)
        assert_equal(4, value_.alpha_version)
        assert_equal(1, value_.alpha_minor)
        assert_equal('2.0.1a4.1', value_.unparse)
        assert_equal('2.0.1a4.1', value_.unparse(:optional_fields => [:alpha_minor]))
      end
      
      
      # Test parsing beta.
      
      def test_parsing_beta
        value_ = Versionomy.parse('2.52.1b4.0')
        assert_equal(2, value_.major)
        assert_equal(52, value_.minor)
        assert_equal(1, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:beta, value_.release_type)
        assert_equal(4, value_.beta_version)
        assert_equal(0, value_.beta_minor)
        assert_equal('2.52.1b4.0', value_.unparse)
        assert_equal('2.52.1b4', value_.unparse(:optional_fields => [:beta_minor]))
      end
      
      
      # Test parsing beta alternates
      
      def test_parsing_beta_alternates
        assert_equal(Versionomy.parse('2.52.1 beta4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1-b4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1.b4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1B4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1BETA4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1 Beta4'), '2.52.1b4')
        assert_equal(Versionomy.parse('2.52.1 eta4'), '2.52.1')
      end
      
      
      # Test parsing release candidate.
      
      def test_parsing_release_candidate
        value_ = Versionomy.parse('0.2rc0')
        assert_equal(0, value_.major)
        assert_equal(2, value_.minor)
        assert_equal(0, value_.tiny)
        assert_equal(0, value_.tiny2)
        assert_equal(:release_candidate, value_.release_type)
        assert_equal(0, value_.release_candidate_version)
        assert_equal(0, value_.release_candidate_minor)
        assert_equal('0.2rc0', value_.unparse)
        assert_equal('0.2rc0.0', value_.unparse(:required_fields => [:release_candidate_minor]))
        assert_equal('0.2rc0', value_.unparse(:optional_fields => [:release_candidate_version]))
      end
      
      
      # Test unparsing a value that requires lookback.
      
      def test_unparsing_with_lookback
        value_ = Versionomy.parse('2.0')
        value2_ = value_.change(:tiny2 => 1)
        assert_equal(1, value2_.tiny2)
        assert_equal('2.0.0.1', value2_.unparse)
        value3_ = value2_.change(:tiny2 => 0)
        assert_equal(0, value3_.tiny2)
        assert_equal('2.0', value3_.unparse)
      end
      
      
      # Test delimiter changes in a multi-form field.
      
      def test_multi_form_delimiter_changes
        value_ = Versionomy.parse('2.0 preview 1')
        assert_equal('2.0 preview 1', value_.to_s)
        value2_ = value_.change(:release_type => :final)
        assert_equal('2.0', value2_.to_s)
        value3_ = value2_.change(:release_type => :preview, :preview_version => 1)
        assert_equal('2.0 preview 1', value3_.to_s)
      end
      
      
      # Test different patchlevel separators.
      
      def test_patchlevel_separators
        expected_ = [1,9,1,0,:final,243,0]
        assert_equal(expected_, Versionomy.parse('1.9.1-p243').values_array)
        assert_equal(expected_, Versionomy.parse('1.9.1p243').values_array)
        assert_equal(expected_, Versionomy.parse('1.9.1.p243').values_array)
        assert_equal(expected_, Versionomy.parse('1.9.1 p243').values_array)
        assert_equal(expected_, Versionomy.parse('1.9.1-243').values_array)
      end
      
      
    end
    
  end
end
