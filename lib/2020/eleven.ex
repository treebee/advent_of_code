defmodule AdventOfCode.TwentyTwenty.Eleven do
  use AdventOfCode

  def solve(filename \\ "eleven.txt") do
    list_grid =
      filename
      |> read_input(trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    map_grid = to_grid(list_grid)

    part1 = occupied_seats(map_grid, length(list_grid), length(Enum.at(list_grid, 0)))
    part2 = occupied_seats(map_grid, length(list_grid), length(Enum.at(list_grid, 0)), :part2)
    {part1, part2}
  end

  def new_val("#", occupied, :part1) when occupied >= 4, do: "L"
  def new_val("#", occupied, :part2) when occupied >= 5, do: "L"
  def new_val("L", occupied, _) when occupied == 0, do: "#"
  def new_val("#", _, _), do: "#"
  def new_val(val, _, _), do: val

  def process(_, _, _, nil, _), do: nil
  def process(_, _, _, ".", _), do: "."

  def process(grid, row, col, seat, :part1) do
    adjacent =
      for i <- -1..1,
          j <- -1..1,
          into: %{},
          do: {{row + i, col + j}, Map.get(grid, {row + i, col + j})}

    new_val(seat, count_occupied(adjacent, row, col), :part1)
  end

  def process(grid, row, col, seat, :part2) do
    adjacent =
      for i <- -1..1,
          j <- -1..1,
          into: %{},
          do: {{row + i, col + j}, next_seat(grid, row + i, col + j, i, j)}

    new_val(seat, count_occupied(adjacent, row, col), :part2)
  end

  def count_occupied(adjacent, row, col) do
    adjacent
    |> Map.delete({row, col})
    |> Map.values()
    |> Enum.count(fn x -> x == "#" end)
  end

  def next_seat(grid, row, col, i, j) do
    case Map.get(grid, {row, col}) do
      "." -> next_seat(grid, row + i, col + j, i, j)
      val -> val
    end
  end

  def occupied_seats(grid, max_rows, max_cols, part \\ :part1) do
    new_grid =
      for {{row, col}, seat} <- grid,
          into: %{},
          do: {{row, col}, process(grid, row, col, seat, part)}

    case grid == new_grid do
      true ->
        new_grid |> Map.values() |> Enum.count(fn x -> x == "#" end)

      false ->
        occupied_seats(new_grid, max_rows, max_cols, part)
    end
  end

  def to_grid(list_grid) do
    for row <- 0..(length(list_grid) - 1),
        col <- 0..(length(Enum.at(list_grid, 0)) - 1),
        into: %{},
        do: {{row, col}, list_grid |> Enum.at(row) |> Enum.at(col)}
  end
end
