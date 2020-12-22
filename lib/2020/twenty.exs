defmodule Tile do
  defstruct [:id, :top, :bottom, :left, :right]

  def fit(self, other) do
    for side_self <- [:top, :bottom, :left, :right],
        side_other <- [:top, :bottom, :left, :right] do
      col_self = Map.get(self, side_self)
      col_other = Map.get(other, side_other)
      col_self == col_other or Enum.reverse(col_self) == col_other
    end
    |> Enum.any?()
  end
end

defmodule AdventOfCode.TwentyTwenty.Twenty do
  use AdventOfCode

  def solve(filename) do
    tiles =
      filename
      |> read_input(trim: true)
      |> Enum.to_list()
      |> parse()
      |> Enum.map(&transform/1)

    tiles
    |> Enum.map(&potential_neighbors(&1, tiles))
    |> Enum.sort_by(fn {_, count} -> count end)
    |> Enum.filter(fn {_, count} -> count == 3 end)
    |> length
    |> IO.inspect()

    # |> Enum.take(4)
    # |> Enum.reduce(1, fn {id, _count}, acc -> id * acc end)
  end

  defp count_potential_neighbors(tile, [], count), do: {tile.id, count}

  defp count_potential_neighbors(
         %Tile{id: id} = tile,
         [%Tile{id: other_id} = other | rest],
         count
       )
       when id != other_id do
    case Tile.fit(tile, other) do
      true -> count_potential_neighbors(tile, rest, count + 1)
      false -> count_potential_neighbors(tile, rest, count)
    end
  end

  defp count_potential_neighbors(tile, [_other | rest], count),
    do: count_potential_neighbors(tile, rest, count)

  defp potential_neighbors(%Tile{id: id} = tile, all_tiles) do
    count_potential_neighbors(tile, all_tiles, 0)
  end

  defp transform({tile_id, tile}) do
    n = Enum.at(tile, 0)
    s = Enum.at(tile, -1)
    w = tile |> Enum.map(&Enum.at(&1, 0))
    e = tile |> Enum.map(&Enum.at(&1, -1))
    %Tile{id: tile_id, top: n, bottom: s, left: w, right: e}
  end

  defp tile_id(line),
    do: line |> String.trim_leading("Tile ") |> String.trim_trailing(":") |> String.to_integer()

  defp parse([line | rest]) do
    tile_id = tile_id(line)
    parse(rest, Map.new(%{tile_id => []}), tile_id)
  end

  defp parse([], tiles, _), do: tiles
  defp parse(["" | rest], tiles, tile_id), do: parse(rest, tiles, tile_id)

  defp parse([line | rest], tiles, tile_id) do
    case String.starts_with?(line, "Tile ") do
      true ->
        tile_id = tile_id(line)
        parse(rest, Map.put(tiles, tile_id, []), tile_id)

      false ->
        parse(
          rest,
          Map.put(tiles, tile_id, Map.get(tiles, tile_id) ++ [String.graphemes(line)]),
          tile_id
        )
    end
  end
end

System.argv() |> List.first() |> AdventOfCode.TwentyTwenty.Twenty.solve() |> IO.inspect()
