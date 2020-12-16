defmodule AdventOfCode.TwentyTwenty.Sixteen do
  use AdventOfCode

  def solve(filename \\ "sixteen.txt") do
    {own_ticket, ranges, valid_tickets, part1} =
      read_input(filename, trim: true)
      |> Enum.to_list()
      |> possible_numbers()
      |> own_ticket()
      |> scan_tickets()

    part2 =
      order_fields(ranges, own_ticket, valid_tickets)
      |> Enum.filter(fn {field, _} -> String.starts_with?(field, "departure") end)
      |> Enum.map(fn {_, n} -> Enum.at(own_ticket, n) end)
      |> Enum.reduce(1, fn x, acc -> x * acc end)

    IO.inspect(part2)
    part1
  end

  def iterate_ranges([], _, ordering, _), do: ordering

  def iterate_ranges([{field, range} | ranges], values, ordering, pos) do
    case MapSet.difference(MapSet.new(values), MapSet.new(range)) |> Enum.to_list() do
      [] ->
        iterate_ranges(
          ranges,
          values,
          Map.put(ordering, pos, [field | Map.get(ordering, pos, [])]),
          pos
        )

      _ ->
        iterate_ranges(
          ranges,
          values,
          ordering,
          pos
        )
    end
  end

  def iterate_ranges(ranges, values, ordering, pos),
    do: iterate_ranges(ranges |> Enum.to_list(), values, ordering, pos)

  def iterate_tickets(positions, ranges, tickets),
    do: iterate_tickets(positions, ranges, tickets, %{})

  def iterate_tickets([], _, _, ordering), do: ordering

  def iterate_tickets([pos | tail], ranges, tickets, ordering) do
    values = for ticket <- tickets, into: [], do: Enum.at(ticket, pos)

    ordering = iterate_ranges(ranges, values, ordering, pos)

    iterate_tickets(tail, ranges, tickets, ordering)
  end

  def find_fields([], mapping), do: mapping

  def find_fields([{pos, [field]} | tail], mapping) do
    find_fields(tail, Map.put(mapping, field, pos))
  end

  def find_fields([{pos, fields} | tail], mapping) do
    find_fields(
      tail ++
        [
          {
            pos,
            MapSet.difference(MapSet.new(fields), MapSet.new(Map.keys(mapping))) |> Enum.to_list()
          }
        ],
      mapping
    )
  end

  def order_fields(fields), do: find_fields(fields, %{})

  def order_fields(ranges, own_ticket, valid_tickets) do
    ordering =
      iterate_tickets(0..(length(own_ticket) - 1) |> Enum.to_list(), ranges, valid_tickets)

    order_fields(ordering |> Enum.to_list())
  end

  def own_ticket({["your ticket:" | lines], ranges}) do
    [ticket_line | remaining_lines] = lines

    {remaining_lines,
     ticket_line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1), ranges}
  end

  def scan_tickets({["nearby tickets:" | lines], own_ticket, valid_numbers}),
    do: scan_tickets(lines, own_ticket, valid_numbers, [], [])

  def scan_tickets({[_ | lines], own_ticket, valid_numbers}),
    do: scan_tickets({lines, own_ticket, valid_numbers})

  def scan_tickets([], own_ticket, valid_numbers, valid_tickets, invalid_values),
    do: {own_ticket, valid_numbers, valid_tickets, Enum.sum(invalid_values)}

  def scan_tickets(
        [ticket | next_tickets],
        own_ticket,
        valid_numbers,
        valid_tickets,
        invalid_values
      ) do
    numbers = String.split(ticket, ",", trim: true) |> Enum.map(&String.to_integer/1)

    {valid_tickets, invalid_values} =
      case MapSet.difference(
             MapSet.new(numbers),
             MapSet.new(Map.values(valid_numbers) |> List.flatten())
           )
           |> Enum.to_list() do
        [] -> {[numbers | valid_tickets], invalid_values}
        invalids -> {valid_tickets, invalids ++ invalid_values}
      end

    scan_tickets(
      next_tickets,
      own_ticket,
      valid_numbers,
      valid_tickets,
      invalid_values
    )
  end

  def possible_numbers(lines), do: possible_numbers(lines, %{})

  def possible_numbers(["" | remaining_lines], numbers),
    do: {remaining_lines, numbers}

  def possible_numbers([line | next_lines], numbers) do
    [field, number_part] = String.split(line, ": ")

    %{"a" => a, "b" => b, "c" => c, "d" => d} =
      Regex.named_captures(~r/(?<a>[\d]+)-(?<b>[\d]+) or (?<c>[\d]+)-(?<d>[\d]+)/, number_part)

    n = String.to_integer(a)..String.to_integer(b) |> Enum.to_list()
    m = String.to_integer(c)..String.to_integer(d) |> Enum.to_list()
    possible_numbers(next_lines, Map.put(numbers, field, n ++ m))
  end
end
