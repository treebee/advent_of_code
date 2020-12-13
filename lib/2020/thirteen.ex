defmodule AdventOfCode.TwentyTwenty.Thirteen do
  use AdventOfCode

  def solve(filename \\ "thirteen.txt") do
    [ts, busses] =
      read_input(filename, trim: true)
      |> Enum.to_list()

    ts = String.to_integer(ts)

    busses =
      busses
      |> String.split(",", trim: true)

    bus_ids =
      busses
      |> Enum.filter(fn x -> x != "x" end)
      |> Enum.map(&String.to_integer/1)

    departures =
      bus_ids
      |> Enum.map(fn bus_id ->
        {bus_id, ts + min(1, rem(ts, bus_id)) * (bus_id - rem(ts, bus_id))}
      end)

    {bus_id, bus_departure_ts} = find_bus(bus_ids, ts, departures)
    part1 = (bus_departure_ts - ts) * bus_id

    bus_offsets =
      busses
      |> Enum.with_index()
      |> Enum.filter(fn {bus_id, _idx} -> bus_id != "x" end)
      |> Enum.map(fn {bus_id, idx} -> {String.to_integer(bus_id), idx} end)

    part2 = find_timestamp(bus_offsets)
    {part1, part2}
  end

  def update(bus, hidx, ts, m) do
    case rem(ts + hidx, bus) do
      0 -> ts
      _ -> update(bus, hidx, ts + m, m)
    end
  end

  def find_timestamp(bus_offsets), do: find_timestamp(bus_offsets, 0, 1)

  def find_timestamp([], ts, _), do: ts

  def find_timestamp([{h, hidx} | bus_offsets], ts, m) do
    find_timestamp(bus_offsets, update(h, hidx, ts, m), m * h)
  end

  def find_bus(busses, ts, departures) do
    {bus_id, bus_departure_ts} =
      departures
      |> Enum.filter(fn {bus_id, bus_departure} -> bus_departure >= ts and bus_id in busses end)
      |> Enum.min_by(fn {_, ts} -> ts end)

    {bus_id, bus_departure_ts}
  end
end
