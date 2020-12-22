defmodule AdventOfCode.TwentyTwenty.TwentyThree do
  def solve(labeling) do
    [1 | cups] =
      labeling
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> play()

    Enum.map(cups, &Integer.to_string/1) |> Enum.join() |> String.to_integer()
  end

  defp reorder([n | tail], n), do: [n | tail]
  defp reorder([h | tail], n), do: reorder(tail ++ [h], n)

  def find_destination(dest, pickup, min, max) when dest < min,
    do: find_destination(max, pickup, min, max)

  def find_destination(dest, pickup, min, max) do
    case dest in pickup do
      true -> find_destination(dest - 1, pickup, min, max)
      false -> dest
    end
  end

  def play(cups, _min, _max, 100), do: reorder(cups, 1)

  def play([curr | rest], min, max, move) do
    {pickup, tail} = Enum.split(rest, 3)
    destination = find_destination(curr - 1, pickup, min, max)
    idx = Enum.find_index([curr | tail], fn label -> label == destination end)
    {front, back} = Enum.split([curr | tail], idx + 1)
    [curr | rest] = reorder(front ++ pickup ++ back, curr)
    play(rest ++ [curr], min, max, move + 1)
  end

  def play(cups), do: play(cups, Enum.min(cups), Enum.max(cups), 0)
end

"916438275" |> AdventOfCode.TwentyTwenty.TwentyThree.solve() |> IO.inspect()
