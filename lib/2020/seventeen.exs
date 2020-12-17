defmodule AdventOfCode.TwentyTwenty.Seventeen do
  use AdventOfCode

  def solve([filename | _]) do
    input =
      filename
      |> read_input(trim: true)
      |> Enum.to_list()
      |> Enum.map(&String.split(&1, "", trim: true))

    part1 =
      input
      |> actives()
      |> execute_cycles(6, 1)

    part2 = input |> actives_hyper() |> execute_cycles_hyper(6, 1)

    {part1, part2}
  end

  defp actives(cube) do
    actives =
      for x <- 0..(length(Enum.at(cube, 0)) - 1),
          y <- 0..(length(cube) - 1),
          do: {{x, y, 0}, cube |> Enum.at(x) |> Enum.at(y)}

    actives
    |> Enum.filter(fn {_, value} -> value == "#" end)
    |> Enum.map(fn {coords, _} -> coords end)
    |> MapSet.new()
  end

  defp actives_hyper(cube) do
    actives =
      for x <- 0..(length(Enum.at(cube, 0)) - 1),
          y <- 0..(length(cube) - 1),
          do: {{x, y, 0, 0}, cube |> Enum.at(x) |> Enum.at(y)}

    actives
    |> Enum.filter(fn {_, value} -> value == "#" end)
    |> Enum.map(fn {coords, _} -> coords end)
    |> MapSet.new()
  end

  defp execute_cycles_hyper(actives, max_cycles, cycle) when max_cycles < cycle,
    do: actives |> Enum.count()

  defp execute_cycles_hyper(actives, max_cycles, cycle) do
    x = actives |> Enum.map(fn {x, _, _, _} -> x end)
    y = actives |> Enum.map(fn {_, y, _, _} -> y end)
    z = actives |> Enum.map(fn {_, _, z, _} -> z end)
    w = actives |> Enum.map(fn {_, _, _, w} -> w end)

    new =
      for i <- (Enum.min(x) - 1)..(Enum.max(x) + 1),
          j <- (Enum.min(y) - 1)..(Enum.max(y) + 1),
          k <- (Enum.min(z) - 1)..(Enum.max(z) + 1),
          l <- (Enum.min(w) - 1)..(Enum.max(w) + 1),
          do: {{i, j, k, l}, process(actives, {i, j, k, l})}

    new =
      new
      |> Enum.filter(fn {_, active} -> active end)
      |> Enum.map(fn {coords, _} -> coords end)
      |> MapSet.new()

    execute_cycles_hyper(new, max_cycles, cycle + 1)
  end

  defp execute_cycles(actives, max_cycles, cycle) when max_cycles < cycle,
    do: actives |> Enum.count()

  defp execute_cycles(actives, max_cycles, cycle) do
    x = actives |> Enum.map(fn {x, _, _} -> x end)
    y = actives |> Enum.map(fn {_, y, _} -> y end)
    z = actives |> Enum.map(fn {_, _, z} -> z end)

    new =
      for i <- (Enum.min(x) - 1)..(Enum.max(x) + 1),
          j <- (Enum.min(y) - 1)..(Enum.max(y) + 1),
          k <- (Enum.min(z) - 1)..(Enum.max(z) + 1),
          do: {{i, j, k}, process(actives, {i, j, k})}

    new =
      new
      |> Enum.filter(fn {_, active} -> active end)
      |> Enum.map(fn {coords, _} -> coords end)
      |> MapSet.new()

    execute_cycles(new, max_cycles, cycle + 1)
  end

  defp process(actives, {x, y, z}) do
    neighbors =
      for i <- -1..1,
          j <- -1..1,
          k <- -1..1,
          !(i == 0 and j == 0 and k == 0),
          do: MapSet.member?(actives, {x + i, y + j, z + k})

    n = neighbors |> Enum.count(fn x -> x end)

    case MapSet.member?(actives, {x, y, z}) do
      true -> n in [2, 3]
      false -> n == 3
    end
  end

  defp process(actives, {x, y, z, w}) do
    neighbors =
      for i <- -1..1,
          j <- -1..1,
          k <- -1..1,
          l <- -1..1,
          !(i == 0 and j == 0 and k == 0 and l == 0),
          do: MapSet.member?(actives, {x + i, y + j, z + k, w + l})

    n = neighbors |> Enum.count(fn x -> x end)

    case MapSet.member?(actives, {x, y, z, w}) do
      true -> n in [2, 3]
      false -> n == 3
    end
  end
end

AdventOfCode.TwentyTwenty.Seventeen.solve(System.argv()) |> IO.inspect()
