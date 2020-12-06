defmodule AdventOfCode2020Test do
  use ExUnit.Case
  alias AdventOfCode.TwentyTwenty.Six

  test "day 6" do
    assert Six.puzzle("six-ex.txt") == 11
    assert Six.puzzle2("six-ex.txt") == 6
  end
end
