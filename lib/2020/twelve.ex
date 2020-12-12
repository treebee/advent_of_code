defmodule AdventOfCode.TwentyTwenty.Twelve do
  use AdventOfCode

  def solve(filename \\ "twelve.txt") do
    instructions =
      filename
      |> read_input(trim: true)
      |> Stream.map(&String.split_at(&1, 1))
      |> Enum.map(fn {d, n} -> [d, String.to_integer(n)] end)

    {instructions |> navigate(), instructions |> navigate2()}
  end

  def navigate(instructions), do: navigate(instructions, {0, 1}, {0, 0})

  def navigate([["F", n] | tail], {dx, dy}, {x, y}) do
    navigate(tail, {dx, dy}, {x + dx * n, y + dy * n})
  end

  def navigate([["N", n] | tail], direction, {x, y}),
    do: navigate(tail, direction, {x + n, y})

  def navigate([["S", n] | tail], direction, {x, y}),
    do: navigate(tail, direction, {x - n, y})

  def navigate([["E", n] | tail], direction, {x, y}),
    do: navigate(tail, direction, {x, y + n})

  def navigate([["W", n] | tail], direction, {x, y}),
    do: navigate(tail, direction, {x, y - n})

  def navigate([[action, n] | tail], {dx, dy}, pos) when {action, n} in [{"R", 90}, {"L", 270}],
    do: navigate(tail, {-1 * dy, dx}, pos)

  def navigate([[action, n] | tail], {dx, dy}, pos) when {action, n} in [{"L", 90}, {"R", 270}],
    do: navigate(tail, {dy, -1 * dx}, pos)

  def navigate([[action, 180] | tail], {dx, dy}, pos) when action in ["R", "L"] do
    navigate(tail, {-1 * dx, -1 * dy}, pos)
  end

  def navigate([], _, {x, y}) do
    abs(x) + abs(y)
  end

  def navigate2(instructions), do: navigate2(instructions, {1, 10}, {0, 0})

  def navigate2([["F", n] | tail], {dx, dy}, {x, y}),
    do: navigate2(tail, {dx, dy}, {x + dx * n, y + dy * n})

  def navigate2([[action, n] | tail], {dx, dy}, pos) when {action, n} in [{"R", 90}, {"L", 270}],
    do: navigate2(tail, {-1 * dy, dx}, pos)

  def navigate2([[action, n] | tail], {dx, dy}, pos) when {action, n} in [{"L", 90}, {"R", 270}],
    do: navigate2(tail, {dy, -1 * dx}, pos)

  def navigate2([[action, 180] | tail], {dx, dy}, pos) when action in ["R", "L"],
    do: navigate2(tail, {-1 * dx, -1 * dy}, pos)

  def navigate2([["N", n] | tail], {dx, dy}, {x, y}), do: navigate2(tail, {dx + n, dy}, {x, y})
  def navigate2([["S", n] | tail], {dx, dy}, {x, y}), do: navigate2(tail, {dx - n, dy}, {x, y})
  def navigate2([["E", n] | tail], {dx, dy}, {x, y}), do: navigate2(tail, {dx, dy + n}, {x, y})
  def navigate2([["W", n] | tail], {dx, dy}, {x, y}), do: navigate2(tail, {dx, dy - n}, {x, y})

  def navigate2([], _, {x, y}) do
    abs(x) + abs(y)
  end
end
