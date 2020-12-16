defmodule AdventOfCode2020Test do
  use ExUnit.Case
  use AdventOfCode
  alias AdventOfCode.TwentyTwenty.Six
  alias AdventOfCode.TwentyTwenty.Seven
  alias AdventOfCode.TwentyTwenty.Eight
  alias AdventOfCode.TwentyTwenty.Nine
  alias AdventOfCode.TwentyTwenty.Ten

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

  test "day 9" do
    assert Nine.solve("nine-ex.txt", 5) == {127, 62}
  end

  test "day 10" do
    assert Ten.solve("ten-ex.txt") == {220, 19208}
  end

  test "day 11" do
    assert AdventOfCode.TwentyTwenty.Eleven.solve("eleven-ex.txt") == {37, 26}
  end

  test "day 12" do
    assert AdventOfCode.TwentyTwenty.Twelve.solve("twelve-ex.txt") == {25, 286}
  end

  test "day 13" do
    assert AdventOfCode.TwentyTwenty.Thirteen.solve("thirteen-ex.txt") == {295, 1_068_781}
  end

  test "day 14" do
    assert AdventOfCode.TwentyTwenty.Fourteen.execute(
             read_input("../lib/2020/fourteen-ex.txt", trim: true)
             |> Enum.to_list()
           ) == 165
  end

  test "day 15" do
    # assert AdventOfCode.TwentyTwenty.Fifteen.solve([0, 3, 6]) == {436, 175_594}
  end

  test "day 16" do
    assert AdventOfCode.TwentyTwenty.Sixteen.solve("sixteen-ex.txt") == 71
  end
end
