defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  defmacro __using__(_) do
    quote do
      def input_path(filename) do
        Path.join(Path.dirname(__ENV__.file), filename)
      end

      def read_input(filename, opts \\ %{}) do
        stream =
          filename
          |> input_path()
          |> File.stream!()

        case Map.get(Map.new(opts), :trim, false) do
          true -> stream |> Stream.map(&String.trim/1)
          false -> stream
        end
      end

      def to_int(d) do
        case Integer.parse(d) do
          {i, ""} -> i
          :error -> d
        end
      end
    end
  end

  def cartesian([]), do: []

  def cartesian(lists) do
    cartesian(Enum.reverse(lists), []) |> Enum.to_list()
  end

  defp cartesian([], elems), do: [elems]

  defp cartesian([h | tail], elems) do
    Stream.flat_map(h, fn x -> cartesian(tail, [x | elems]) end)
  end
end
