defmodule AdventOfCode.TwentyTwenty.TwentyTwo do
  use AdventOfCode

  def solve(filename) do
    lines =
      filename
      |> read_input(trim: true)
      |> Stream.filter(fn x -> not String.starts_with?(x, "Player") end)
      |> Stream.map(fn x ->
        if x != "" do
          String.to_integer(x)
        else
          x
        end
      end)
      |> Enum.to_list()

    {deck1, ["" | deck2]} = Enum.split(lines, Enum.find_index(lines, fn x -> x == "" end))
    play(deck1, deck2)
  end

  defp score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.zip(1..length(deck))
    |> Enum.reduce(0, fn {x, y}, acc -> x * y + acc end)
  end

  defp play(deck1, []), do: score(deck1)
  defp play([], deck2), do: score(deck2)

  defp play([h1 | deck1], [h2 | deck2]) do
    case h1 > h2 do
      true -> play(deck1 ++ [h1, h2], deck2)
      false -> play(deck1, deck2 ++ [h2, h1])
    end
  end
end

System.argv() |> List.first() |> AdventOfCode.TwentyTwenty.TwentyTwo.solve() |> IO.inspect()
