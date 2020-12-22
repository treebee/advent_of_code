defmodule AdventOfCode.TwentyTwenty.TwentyTwo do
  use AdventOfCode

  def solve(filename) do
    lines =
      filename
      |> read_input(trim: true)
      |> Stream.filter(fn x -> not String.starts_with?(x, "Player") end)
      |> Stream.map(&to_int/1)
      |> Enum.to_list()

    {deck1, ["" | deck2]} = Enum.split(lines, Enum.find_index(lines, fn x -> x == "" end))
    {play(deck1, deck2), rplay(deck1, deck2)}
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

  defp rplay(deck1, deck2), do: rplay(deck1, deck2, 1, [])

  defp rplay(_deck1, [], game, _history) when game > 1, do: :one
  defp rplay([], _deck2, game, _history) when game > 1, do: :two
  defp rplay(deck1, [], _game, _history), do: score(deck1)
  defp rplay([], deck2, _game, _history), do: score(deck2)

  defp rplay([h1 | deck1], [h2 | deck2], game, history) do
    order = {score([h1 | deck1]), score([h2 | deck2])}

    case order in history do
      true ->
        case game > 1 do
          true ->
            :one

          false ->
            rplay(deck1 ++ [h1, h2], deck2, game, [order | history])
        end

      false ->
        case h1 > h2 do
          true -> rplay(deck1 ++ [h1, h2], deck2, game, [order | history])
          false -> rplay(deck1, deck2 ++ [h2, h1], game, [order | history])
        end
    end
  end

  defp rplay([h1 | deck1], [h2 | deck2], game, history)
       when length(deck1) >= h1 and length(deck2) >= h2 do
    order = {score([h1 | deck1]), score([h2 | deck2])}

    case rplay(Enum.take(deck1, h1), Enum.take(deck2, h2), game + 1, []) do
      :one -> rplay(deck1 ++ [h1, h2], deck2, game, [order | history])
      :two -> rplay(deck1, deck2 ++ [h2, h1], game, [order | history])
    end
  end
end

Benchee.run(%{
"day20" => fn -> System.argv() |> List.first() |> AdventOfCode.TwentyTwenty.TwentyTwo.solve() end
})
