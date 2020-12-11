defmodule AdventOfCode.TwentyTwenty.Ten do
  use AdventOfCode

  def solve(filename \\ "ten.txt") do
    adapters =
      filename
      |> read_input(trim: true)
      |> Stream.map(&String.to_integer/1)
      |> Enum.sort()

    dists =
      adapters
      |> distances(0, [])

    part1 = Enum.count(dists, fn x -> x == 1 end) * Enum.count(dists, fn x -> x == 3 end)
    part2 = combinations(adapters)

    # alternative solution (part2):
    # group distances, only adatpers in [1]-groups can be re-arranged, e.g.
    # when you have
    # adapters = [0, 1, 2, 3, 6, 7, 8, 11] the distances are
    # distances = [1, 1, 1, 3, 1, 1, 3]
    # grouped it looks like [[1, 1, 1], [3], [1, 1], [3]]
    # for the group [1, 1, 1] (which corresponds to [1, 2, 3]) there are 4 possible combinations:
    # [1, 2, 3], [1, 3], [2, 3], [3]

    # in the [1, 1] group has the value 2, using the 7 or leaving it out
    # =>
    # [1] -> 1
    # [1, 1] -> 2
    # [1, 1, 1] -> 4
    # [1, 1, 1, 1] -> 7
    # with that, you can group the distances and then assign values and multiply everything
    dists
    |> group()
    |> Enum.filter(fn g -> 3 not in g end)
    |> Enum.map(&group_value/1)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
    |> IO.inspect()

    {part1, part2}
  end

  def group_value(group) do
    case length(group) do
      1 -> 1
      2 -> 2
      3 -> 4
      4 -> 7
      6 -> 22
    end
  end

  def distances([h | t], 0, []) do
    distances(t, h, [h])
  end

  def distances([], _, dists) do
    [3 | dists]
  end

  def distances([h | t], previous, dists) do
    distances(t, h, [abs(h - previous) | dists])
  end

  def combinations(list), do: combinations(%{0 => 1}, [0 | Enum.sort(list)])

  def combinations(acc, [last]) do
    acc[last]
  end

  def combinations(acc, [h | tail]) do
    tail
    |> Enum.take(3)
    |> reachable(h, acc)
    |> combinations(tail)
  end

  def reachable([], _, acc), do: acc

  def reachable([h | tail], cur, acc) when h - cur <= 3 do
    acc = Map.update(acc, h, acc[cur], &(&1 + acc[cur]))
    reachable(tail, cur, acc)
  end

  def reachable([_ | tail], cur, acc), do: reachable(tail, cur, acc)

  def group(list), do: group(list, [])

  def group([h | tail], []) do
    group(tail, [[h]])
  end

  def group([], g) do
    g
  end

  def group([h | tail], [gh | gtail]) do
    case h in gh do
      true -> group(tail, [[h] ++ gh | gtail])
      false -> group(tail, [[h] | [gh | gtail]])
    end
  end
end
