defmodule AdventOfCode.TwentyTwenty.Eight do
  use AdventOfCode

  def solve(filename \\ "seven.txt") do
    program =
      read_input(filename)
      |> Enum.map(&String.trim/1)
      |> Enum.to_list()

    {:broken, part1, possibly_broken} =
      program
      |> execute_program(0, {0, []}, [])

    part2 = fix_program(program, possibly_broken)

    {part1, part2}
  end

  defp fix_line(line) do
    case String.starts_with?(line, "jmp") do
      true -> String.replace(line, "jmp", "nop")
      false -> String.replace(line, "nop", "jmp")
    end
  end

  defp fix_program(program, [{line_number, acc} | possibly_broken]) do
    {front, [_ | tail]} = Enum.split(program, line_number)
    fixed_program = front ++ [Enum.at(program, line_number) |> fix_line() | tail]

    case execute_program(fixed_program, line_number, {acc, []}, []) do
      {:fixed, acc, _} -> acc
      {:broken, _, _} -> fix_program(program, possibly_broken)
    end
  end

  defp execute_program(program, line_number, {acc, executed_lines}, possibly_broken) do
    case line_number in executed_lines do
      true ->
        {:broken, acc, possibly_broken}

      false ->
        case Enum.at(program, line_number) do
          nil ->
            {:fixed, acc, []}

          program_line ->
            {acc, next_line, possibly_broken} =
              execute_line(program_line |> String.split(), line_number, acc, possibly_broken)

            execute_program(
              program,
              next_line,
              {acc, [line_number | executed_lines]},
              possibly_broken
            )
        end
    end
  end

  defp execute_line(["nop", _], line_number, acc, possibly_broken) do
    {acc, line_number + 1, [{line_number, acc} | possibly_broken]}
  end

  defp execute_line(["acc", num], line_number, acc, pb) do
    {acc + String.to_integer(num), line_number + 1, pb}
  end

  defp execute_line(["jmp", num], line_number, acc, possibly_broken) do
    {acc, line_number + String.to_integer(num), [{line_number, acc} | possibly_broken]}
  end
end
