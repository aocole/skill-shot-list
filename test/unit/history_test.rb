require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  test "reconstruct changes" do
    assert no_error do
      changes = History.reconstruct_changes
    end
  end
end
