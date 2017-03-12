require 'test_helper'

class KindlemdTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kindlemd::VERSION
  end
end
