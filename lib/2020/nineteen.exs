defmodule AdventOfCode.TwentyTwenty.Nineteen do
  use AdventOfCode

  def solve(filename) do
    stream = filename |> read_input(trim: true)

    lines =
      stream
      |> Enum.filter(fn line ->
        not String.contains?(line, ":") and line != ""
      end)

    max_len =
      lines
      |> Enum.max(fn x, y -> String.length(x) <= String.length(y) end)
      |> String.length()

    rule =
      stream
      |> Enum.filter(fn line -> String.contains?(line, ":") end)
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.map(fn [n, rule] -> {n, parse_rule(rule)} end)
      |> Map.new()
      |> create_rules(max_len)
      |> Map.get("0")

    # File.write!("r.regex", rule |> Enum.join())

    rule =
      (["^" | rule] ++ ["$"])
      |> Enum.join()
      |> Regex.compile!()
      |> IO.inspect()

    messages =
      lines
      |> Enum.filter(fn line ->
        String.match?(line, rule)
      end)

    messages |> length
  end

  defp replace_rule(rule, rule_map) do
    case is_digit(rule) and rule not in ["a", "b"] do
      true ->
        r = Map.get(rule_map, rule)

        case r not in ["a", "b"] and Enum.member?(r, "|") do
          true -> ["(" | [Map.get(rule_map, rule)] |> List.flatten()] ++ [")"]
          false -> r
        end

      false ->
        rule
    end
  end

  defp create_rules(rule_map, 0), do: rule_map

  defp create_rules(rule_map, depth) do
    rules = Map.get(rule_map, "0")

    case rules |> Enum.map(&is_digit/1) |> Enum.any?() do
      true ->
        rule_map =
          Map.put(
            rule_map,
            "0",
            rules |> Enum.map(&replace_rule(&1, rule_map)) |> List.flatten()
          )

        Map.get(rule_map, "0") |> Enum.join("") |> IO.inspect()
        create_rules(rule_map, depth - 1)

      false ->
        rule_map
    end
  end

  defp is_digit(ch) do
    case Integer.parse(ch) do
      :error -> false
      _ -> true
    end
  end

  defp parse_rule("\"a\""), do: "a"
  defp parse_rule("\"b\""), do: "b"
  defp parse_rule(rule), do: String.split(rule)
end

# needs a better solution for part2
# but the generated regex works (checked with feeding it to python)
IO.inspect(AdventOfCode.TwentyTwenty.Nineteen.solve(System.argv()))
