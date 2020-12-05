defmodule AdventOfCode.TwentyTwenty.Four do
  use AdventOfCode

  @required ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def puzzle(filename \\ "four.txt") do
    filename
    |> read_input()
    |> solve_puzzle()
  end

  defp check_passport(passport) do
    case MapSet.difference(MapSet.new(@required), MapSet.new(Map.keys(passport))) == MapSet.new() do
      false ->
        0

      # true -> 1
      true ->
        check_fields(passport)
    end
  end

  defp check_field("byr", value) do
    value = String.to_integer(value)
    1920 <= value and value <= 2002
  end

  defp check_field("iyr", value) do
    value = String.to_integer(value)
    2010 <= value and value <= 2020
  end

  defp check_field("eyr", value) do
    value = String.to_integer(value)
    2020 <= value and value <= 2030
  end

  defp check_field("hgt", value) do
    case String.split_at(value, -2) do
      {year, "cm"} -> 150 <= String.to_integer(year) and String.to_integer(year) <= 193
      {year, "in"} -> 59 <= String.to_integer(year) and String.to_integer(year) <= 76
      _ -> false
    end
  end

  defp check_field("hcl", value) do
    String.match?(value, ~r/^#[0-9a-f]{6}$/)
  end

  defp check_field("ecl", value) do
    MapSet.member?(MapSet.new(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]), value)
  end

  defp check_field("pid", value) do
    String.match?(value, ~r/^[0-9]{9}$/)
  end

  defp check_field(_, _) do
    true
  end

  defp check_fields(passport) do
    case passport
         |> Enum.map(fn {key, value} -> check_field(key, value) end)
         |> Enum.all?() do
      true -> 1
      false -> 0
    end
  end

  def solve_puzzle(stream) do
    stream
    |> Enum.to_list()
    |> to_passports(0, [])
    |> Enum.reduce(0, fn passport, acc -> check_passport(passport) + acc end)
  end

  defp to_passports([], _current_line, passports) do
    passports
  end

  defp to_passports(["\n" | tail], current_line, passports) do
    to_passports(tail, current_line + 1, passports)
  end

  defp to_passports([line | tail], current_line, passports) do
    passport = Enum.at(passports, current_line, %{})

    passport =
      for [x, y] <-
            String.split(String.trim(line)) |> Enum.map(fn pair -> String.split(pair, ":") end),
          into: passport,
          do: {x, y}

    passports =
      case Enum.split(passports, current_line) do
        {[], []} -> [passport]
        {front, []} -> front ++ [passport]
        {front, [_ | tail]} -> front ++ [passport | tail]
      end

    to_passports(tail, current_line, passports)
  end
end
