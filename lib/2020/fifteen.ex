defmodule AdventOfCode.TwentyTwenty.Fifteen do
  def solve(input \\ [1, 20, 8, 12, 0, 14]) do
    part1 = solve(input, 1, %{}, 2020)
    part2 = solve(input, 1, %{}, 30_000_000)
    {part1, part2}
  end

  def solve([h | []], round, _, end_turn) when round == end_turn, do: h

  def solve([h | []], round, memory, end_turn) do
    next =
      case Map.get(memory, h) do
        nil -> 0
        last -> round - last
      end

    solve([next], round + 1, Map.put(memory, h, round), end_turn)
  end

  def solve([h | tail], round, memory, end_turn) do
    solve(tail, round + 1, Map.put(memory, h, round), end_turn)
  end
end
