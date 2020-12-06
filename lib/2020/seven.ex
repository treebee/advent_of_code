defmodule AdventOfCode.TwentyTwenty.Seven do
  use AdventOfCode

  @mybag "shiny gold"

  def solve(filename \\ "seven.txt") do
    input = filename |> read_input() |> Enum.to_list()
    graph = input |> parse_input(%{})

    part1 =
      graph
      |> Enum.map(fn {_, inner_bags} ->
        evaluate_bag(graph, inner_bags |> Enum.map(fn {color, _} -> color end))
      end)
      |> Enum.sum()

    part2 = count_bags(graph, @mybag)

    {part1, part2}
  end

  def count_bags(_, nil), do: 1

  def count_bags(graph, color) do
    case Map.get(graph, color) do
      [] ->
        0

      inner ->
        inner |> Enum.map(fn {color, n} -> n + n * count_bags(graph, color) end) |> Enum.sum()
    end
  end

  def parse_line(line, bags) do
    {bag, inner_bags} =
      case String.split(line, "bags contain") |> Enum.map(&String.trim/1) do
        [bag, "no other bags."] ->
          {bag, []}

        [bag, bag_rules] ->
          {bag,
           bag_rules
           |> String.split(",")
           |> Stream.map(&String.trim/1)
           |> Stream.map(&String.trim(&1, "."))
           |> Stream.map(&String.split/1)
           |> Enum.map(fn [n, flavor, color, _] ->
             {Enum.join([flavor, " ", color]), String.to_integer(n)}
           end)}
      end

    Map.put(bags, bag, inner_bags)
  end

  def parse_input([], bags) do
    bags
  end

  def parse_input([line | tail], bags) do
    parse_input(tail, parse_line(line, bags))
  end

  def evaluate_bag(_, nil), do: 0

  def evaluate_bag(graph, inner_bags) do
    case @mybag in inner_bags do
      true ->
        1

      false ->
        traverse_path(graph, inner_bags)
    end
  end

  def traverse_path(_, []), do: 0

  def traverse_path(graph, [next | path]) do
    case Map.get(graph, next) do
      nil ->
        0

      next_path ->
        min(
          evaluate_bag(graph, next_path |> Enum.map(fn {color, _} -> color end)) +
            traverse_path(graph, path),
          1
        )
    end
  end
end
