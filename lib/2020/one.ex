defmodule AdventOfCode.TwentyTwenty.One do
  use AdventOfCode

  def puzzle1() do
    read_input("one-1.txt")
    |> parse_input()
    |> solve_puzzle1()
  end

  def puzzle2() do
    read_input("one-1.txt")
    |> parse_input()
    |> solve_puzzle2()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort(&(&1 >= &2))
  end

  def solve_puzzle1(numbers) do
    combinations = for i <- numbers, j <- numbers, into: %{}, do: {i + j, i * j}

    combinations[2020]
  end

  def solve_puzzle2(numbers) do
    combinations =
      for i <- numbers, j <- numbers, k <- numbers, into: %{}, do: {i + j + k, i * j * k}

    combinations[2020]
  end
end
