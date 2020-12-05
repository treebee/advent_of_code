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
      |> parse_input
      |> Enum.to_list()

    {pred, curr, succ} = calc_seats(seats, [], [], [])

    MapSet.difference(MapSet.intersection(pred, succ), curr)
  end

  defp calc_seats([], pred, curr, succ) do
    {MapSet.new(pred), MapSet.new(curr), MapSet.new(succ)}
  end

  defp calc_seats([h | tail], pred, curr, succ) do
    calc_seats(tail, [h - 1 | pred], [h | curr], [h + 1 | succ])
  end

  defp parse_input(filename) do
    filename
    |> input_path()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      String.replace(line, ["F", "L"], "0") |> String.replace(["B", "R"], "1")
    end)
    |> Stream.map(fn line ->
      {b, _} = Integer.parse(line, 2)
      b
    end)
  end
end
