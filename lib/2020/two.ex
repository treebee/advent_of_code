defmodule AdventOfCode.TwentyTwenty.Two do
  use AdventOfCode

  def puzzle1(filename \\ "two.txt") do
    read_input(filename)
    |> parse_input()
    |> Enum.count(&password_valid1/1)
  end

  def puzzle2(filename \\ "two.txt") do
    read_input(filename)
    |> parse_input()
    |> Enum.count(&password_valid2/1)
  end

  def password_valid1({[lower, upper], letter, password}) do
    num_occurences =
      password
      |> String.graphemes()
      |> Enum.count(fn c -> c == letter end)

    lower <= num_occurences and num_occurences <= upper
  end

  def password_valid2({[first, second], letter, password}) do
    g = String.graphemes(password)

    Enum.count([Enum.at(g, first - 1) == letter, Enum.at(g, second - 1) == letter], fn b ->
      b == true
    end) == 1
  end

  def parse_limits(limits) do
    limits
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_input(input) do
    input
    |> Stream.map(fn line -> String.split(line, ":") end)
    |> Stream.map(fn [rules, password] -> [String.split(rules), String.trim(password)] end)
    |> Stream.map(fn [[limits, letter], password] ->
      {parse_limits(limits), String.trim(letter), password}
    end)
  end
end
