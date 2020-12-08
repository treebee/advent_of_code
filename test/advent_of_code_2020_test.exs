defmodule AdventOfCode2020Test do
  use ExUnit.Case
  alias AdventOfCode.TwentyTwenty.Six
  alias AdventOfCode.TwentyTwenty.Seven
  alias AdventOfCode.TwentyTwenty.Eight

  test "day 6" do
    assert Six.puzzle("six-ex.txt") == 11
    assert Six.puzzle2("six-ex.txt") == 6
  end

  test "day 7" do
    assert Seven.solve("seven-ex.txt") == {4, 32}
  end

  test "day 8" do
    assert Eight.solve("eight-ex.txt") == {5, 8}
  end
end
