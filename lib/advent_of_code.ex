defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  defmacro __using__(_) do
    quote do
      def input_path(filename) do
        Path.join(Path.dirname(__ENV__.file), filename)
      end

      def read_input(filename) do
        filename
        |> input_path()
        |> File.stream!()
      end
    end
  end
end
