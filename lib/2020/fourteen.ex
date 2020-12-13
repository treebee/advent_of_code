defmodule AdventOfCode.TwentyTwenty.Fourteen do
  use AdventOfCode
  use Bitwise

  def solve(filename \\ "fourteen.txt") do
    program =
      read_input(filename, trim: true)
      |> Enum.to_list()

    part1 =
      program
      |> execute()

    part2 = program |> execute_v2()
    {part1, part2}
  end

  defp x_to_one("X"), do: "1"
  defp x_to_one(x), do: x

  defp x_to_zero("X"), do: "0"
  defp x_to_zero(x), do: x

  defp to_or_mask(mask) do
    {or_mask, ""} =
      mask
      |> String.split("", trim: true)
      |> Enum.map(fn x -> x_to_zero(x) end)
      |> Enum.join()
      |> Integer.parse(2)

    or_mask
  end

  def parse_mask(mask) do
    {and_mask, ""} =
      mask
      |> String.split("", trim: true)
      |> Enum.map(fn x -> x_to_one(x) end)
      |> Enum.join()
      |> Integer.parse(2)

    {to_or_mask(mask), and_mask}
  end

  def execute(program), do: execute(program, %{}, {0, 0})

  def execute([], memory, _), do: Map.values(memory) |> Enum.sum()

  def execute([line | program], memory, {or_mask, and_mask}) do
    case String.split(line, " = ") do
      ["mask", mask] ->
        execute(program, memory, parse_mask(mask))

      _ ->
        %{"address" => address, "value" => value} =
          Regex.named_captures(~r/mem\[(?<address>[\d]+)\] = (?<value>[\d]+)/, line)

        memory = Map.put(memory, address, (String.to_integer(value) ||| or_mask) &&& and_mask)
        execute(program, memory, {or_mask, and_mask})
    end
  end

  def execute_v2(program), do: execute_v2(program, %{}, 0)

  def execute_v2([], memory, _), do: Map.values(memory) |> Enum.sum()

  def execute_v2([line | program], memory, mask) do
    case String.split(line, " = ") do
      ["mask", mask] ->
        execute_v2(program, memory, mask)

      _ ->
        %{"address" => address, "value" => value} =
          Regex.named_captures(~r/mem\[(?<address>[\d]+)\] = (?<value>[\d]+)/, line)

        or_mask = to_or_mask(mask)

        result =
          (String.to_integer(address) ||| or_mask)
          |> Integer.to_string(2)
          |> String.pad_leading(36, "0")

        x_indices =
          mask
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.filter(fn {x, _} -> x == "X" end)
          |> Enum.map(fn {_, i} -> i end)

        result = insert_x(result, x_indices)

        combinations =
          AdventOfCode.cartesian(
            1..length(x_indices)
            |> Enum.map(fn _ -> ["1", "0"] end)
          )

        memory = update_memory(memory, value, result, combinations)
        execute_v2(program, memory, mask)
    end
  end

  def get_address(address, []), do: address

  def get_address(address, [h | tail]),
    do: get_address(String.replace(address, "X", h, global: false), tail)

  def update_memory(memory, _, _, []), do: memory

  def update_memory(memory, value, result, [h | tail]) do
    address = get_address(result, h)
    update_memory(Map.put(memory, address, String.to_integer(value)), value, result, tail)
  end

  defp insert_x(s, []), do: s

  defp insert_x(s, [i | x_indices]) do
    s =
      case s |> String.graphemes() |> Enum.split(i) do
        {[], [_ | tail]} -> ["X" | tail] |> Enum.join()
        {front, [_ | tail]} -> (front ++ ["X" | tail]) |> Enum.join()
      end

    insert_x(s, x_indices)
  end
end
