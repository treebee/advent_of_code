defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "cartesian product" do
    assert AdventOfCode.cartesian([[1, 0], [1, 0]]) |> MapSet.new() ==
             [[1, 1], [1, 0], [0, 1], [0, 0]] |> MapSet.new()

    assert AdventOfCode.cartesian([[1, 0], [1, 0], [1, 0]]) |> MapSet.new() ==
             [
               [1, 1, 1],
               [1, 1, 0],
               [1, 0, 1],
               [0, 1, 1],
               [1, 0, 0],
               [0, 1, 0],
               [0, 0, 1],
               [0, 0, 0]
             ]
             |> MapSet.new()
  end
end
