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
    end
  end
end
