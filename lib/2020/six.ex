defmodule AdventOfCode.TwentyTwenty.Six do
  use AdventOfCode

  def puzzle(filename \\ "six.txt") do
    read_input(filename)
    |> to_groups()
    |> Enum.map(fn group ->
      Enum.reduce(group, MapSet.new(), fn g, acc -> MapSet.union(MapSet.new(g), acc) end)
    end)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def puzzle2(filename \\ "six.txt") do
    a_to_z = MapSet.new(Enum.map(?a..?z, fn x -> <<x::utf8>> end))

    read_input(filename)
    |> to_groups()
    |> Enum.map(fn group ->
      Enum.reduce(group, a_to_z, fn g, acc -> MapSet.intersection(MapSet.new(g), acc) end)
    end)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sum()
  end

  defp to_groups(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> group_answers([], [])
  end

  defp group_answers([], current_group, groups) do
    [current_group | groups]
  end

  defp group_answers(["" | tail], current_group, groups) do
    group_answers(tail, [], [current_group | groups])
  end

  defp group_answers([line | tail], current_group, groups) do
    group_answers(tail, [String.graphemes(line) | current_group], groups)
  end
end
