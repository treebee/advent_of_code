defmodule AdventOfCode.TwentyTwenty.Twelve do
  use AdventOfCode
  @opposite_dirs %{"E" => "W", "W" => "E", "N" => "S", "S" => "N"}
  def solve(filename \\ "twelve.txt") do
    instructions =
      filename
      |> read_input(trim: true)
      |> Stream.map(&String.split_at(&1, 1))
      |> Enum.map(fn {d, n} -> [d, String.to_integer(n)] end)

    {instructions |> navigate(), instructions |> navigate2()}
  end

  def rotate("E", "R", 90), do: "S"
  def rotate("S", "R", 90), do: "W"
  def rotate("W", "R", 90), do: "N"
  def rotate("N", "R", 90), do: "E"
  def rotate("E", "L", 90), do: "N"
  def rotate("S", "L", 90), do: "E"
  def rotate("W", "L", 90), do: "S"
  def rotate("N", "L", 90), do: "W"
  def rotate("E", "R", 270), do: "N"
  def rotate("S", "R", 270), do: "E"
  def rotate("W", "R", 270), do: "S"
  def rotate("N", "R", 270), do: "W"
  def rotate("E", "L", 270), do: "S"
  def rotate("S", "L", 270), do: "W"
  def rotate("W", "L", 270), do: "N"
  def rotate("N", "L", 270), do: "E"
  def rotate(face, _, 180), do: Map.get(@opposite_dirs, face)

  def navigate(instructions), do: navigate(instructions, "E", %{})

  def navigate([["F", n] | tail], facing, acc),
    do: navigate(tail, facing, Map.put(acc, facing, Map.get(acc, facing, 0) + n))

  def navigate([["R", n] | tail], "E", acc), do: navigate(tail, rotate("E", "R", n), acc)
  def navigate([["L", n] | tail], "E", acc), do: navigate(tail, rotate("E", "L", n), acc)

  def navigate([[direction, n] | tail], facing, acc),
    do: navigate(tail, facing, Map.put(acc, direction, Map.get(acc, direction, 0) + n))

  def navigate([], _, acc) do
    abs(Map.get(acc, "N", 0) - Map.get(acc, "S", 0)) +
      abs(Map.get(acc, "E", 0) - Map.get(acc, "W", 0))
  end

  def move([], _, _, acc), do: acc

  def move([direction | tail], waypoint, n, acc) do
    move(
      tail,
      waypoint,
      n,
      Map.put(acc, direction, Map.get(acc, direction, 0) + n * Map.get(waypoint, direction))
    )
  end

  def navigate2(instructions), do: navigate2(instructions, %{"E" => 10, "N" => 1}, %{})

  def navigate2([["F", n] | tail], waypoint, acc) do
    acc = move(Map.keys(waypoint), waypoint, n, acc)
    navigate2(tail, waypoint, acc)
  end

  def navigate2([[action, n] | tail], waypoint, acc) when action in ["R", "L"] do
    waypoint =
      for {direction, value} <- waypoint, into: %{}, do: {rotate(direction, action, n), value}

    navigate2(tail, waypoint, acc)
  end

  def navigate2([[dir, n] | tail], waypoint, acc) do
    waypoint = Map.put(waypoint, dir, Map.get(waypoint, dir, 0) + n)
    navigate2(tail, waypoint, acc)
  end

  def navigate2([], wp, acc) do
    navigate([], wp, acc)
  end
end
