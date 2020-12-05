defmodule AdventOfCode2020Test do
  use ExUnit.Case
  alias AdventOfCode.TwentyTwenty.Five

  test "day 5" do
    assert Five.find_seat_id("BFFFBBFRRR") == 567
  end
end
