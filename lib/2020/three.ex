defmodule AdventOfCode.TwentyTwenty.Three do
  use AdventOfCode

  def puzzle(filename \\ "three.txt") do
    filename
    |> read_input()
    |> Enum.map(&String.trim/1)
    |> solve_puzzle(0, 0, 3, 1)
  end

  def puzzle2(filename \\ "three.txt") do
    map =
      filename
      |> read_input()
      |> Enum.map(&String.trim/1)

    results =
      for {dx, dy} <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}],
          into: [],
          do: solve_puzzle(map, 0, 0, dx, dy)

    IO.inspect(results)
    Enum.reduce(results, 1, fn e, acc -> e * acc end)
  end

  def read_coordinate(map, x, y) do
    line = Enum.at(map, y)
    String.at(line, rem(x, String.length(line)))
  end

  def coordinate_value(map, x, y) do
    case read_coordinate(map, x, y) do
      "." -> 0
      "#" -> 1
      err -> IO.puts("What?! #{err}")
    end
  end

  defp solve_puzzle(map, x, y, dx, dy, acc \\ 0)

  defp solve_puzzle(map, x, y, dx, dy, acc) when y < length(map) - dy do
    acc = coordinate_value(map, x + dx, y + dy) + acc
    solve_puzzle(map, x + dx, y + dy, dx, dy, acc)
  end

  defp solve_puzzle(map, _, y, _, dy, acc) when y >= length(map) - dy do
    acc
  end
end
