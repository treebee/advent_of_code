defmodule AdventOfCode.TwentyTwenty.Nine do
  use AdventOfCode

  def solve(filename \\ "nine.txt", len \\ 25) do
    numbers =
      read_input(filename, trim: true)
      |> Enum.map(&String.to_integer/1)

    broken = find_number(numbers, [], len)
    weakness = find_weakness(numbers, broken)
    {broken, weakness}
  end

  def shift([head | numbers], [], broken) do
    shift(numbers, [head], broken)
  end

  def shift([head | tail], range, broken) do
    sum = Enum.sum([head | range])

    cond do
      sum == broken or sum > broken -> {sum, [head | range]}
      sum < broken -> shift(tail, [head | range], broken)
    end
  end

  def find_weakness([head | numbers], broken) do
    {result, range} = shift([head | numbers], [], broken)

    cond do
      result == broken -> Enum.min(range) + Enum.max(range)
      result > broken -> find_weakness(numbers, broken)
    end
  end

  def find_number(_, _, len \\ 25)

  def find_number(numbers, [], len) do
    {preamble, next} = Enum.split(numbers, len)
    find_number(next, preamble, len)
  end

  def find_number([next | tail], [_ | ptail] = previous, len) do
    case is_valid?(next, previous) do
      true -> find_number(tail, ptail ++ [next], len)
      false -> next
    end
  end

  def is_valid?(number, [next_prev | tail]) do
    combinations = for i <- tail, into: [], do: next_prev + i

    case number in combinations do
      true -> true
      false -> is_valid?(number, tail)
    end
  end

  def is_valid?(_, []), do: false
end
