defmodule AdventOfCode.TwentyTwenty.Five do
  use AdventOfCode

  def puzzle(filename \\ "five.txt") do
    filename
    |> parse_input()
    |> Enum.max()
  end

  def puzzle2(filename \\ "five.txt") do
    seats =
      filename
      |> parse_input()
      |> Enum.to_list()

    MapSet.difference(MapSet.new(Enum.min(seats)..Enum.max(seats)), MapSet.new(seats))
    |> MapSet.to_list()
    |> List.first()
  end

  defp parse_input(filename) do
    filename
    |> read_input(trim: true)
    |> Stream.map(fn line ->
      String.replace(line, ["F", "L"], "0") |> String.replace(["B", "R"], "1")
    end)
    |> Stream.map(fn line ->
      {b, _} = Integer.parse(line, 2)
      b
    end)
  end
end
