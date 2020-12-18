defmodule Token do
  defstruct [:type, :value]
end

defmodule Parser do
  defstruct [:curr, :peek, :tokens]

  def from_tokens([curr | []]), do: %Parser{curr: curr}

  def from_tokens([curr | [peek | tokens]]) do
    %Parser{curr: curr, peek: peek, tokens: tokens}
  end

  defp next_token(%Parser{tokens: []} = p) do
    %{p | curr: p.peek, peek: nil}
  end

  defp next_token(%Parser{} = p) do
    [next_peek | rest] = p.tokens
    %{p | curr: p.peek, peek: next_peek, tokens: rest}
  end

  defp factor(%Parser{curr: curr} = p) do
    case curr.type do
      :integer ->
        {curr.value, next_token(p)}

      :lparen ->
        {result, p} = expr(next_token(p))
        {result, next_token(p)}
    end
  end

  def term(%Parser{curr: curr} = p, result) when curr == nil or curr.type != :add, do: {result, p}

  def term(%Parser{curr: curr} = p, result) do
    p = next_token(p)
    {res, p} = factor(p)
    term(p, result + res)
  end

  def term(%Parser{} = p) do
    {result, p} = factor(p)
    term(p, result)
  end

  def expr(%Parser{curr: curr} = p, result) when curr == nil or curr.type != :mul,
    do: {result, p}

  def expr(%Parser{curr: curr} = p, result) do
    p = next_token(p)
    {res, p} = term(p)
    expr(p, result * res)
  end

  def expr(%Parser{curr: curr, peek: nil}), do: {curr.value, %Parser{}}

  def expr(%Parser{} = p) do
    {result, p} = term(p)
    expr(p, result)
  end
end

defmodule AdventOfCode.TwentyTwenty.Eighteen do
  use AdventOfCode

  def solve(filename) do
    filename
    |> read_input(trim: true)
    |> Stream.map(&evaluate/1)
    |> Enum.reduce(0, fn {x, _}, acc -> x + acc end)
  end

  # NOTE: graphemes only works here because no number is larger than 9
  def evaluate(line),
    do:
      line
      |> String.graphemes()
      |> Enum.filter(fn x -> x != " " end)
      |> Enum.map(&to_token/1)
      |> Parser.from_tokens()
      |> Parser.expr()
      |> IO.inspect()

  defp to_token("("), do: %Token{type: :lparen}
  defp to_token(")"), do: %Token{type: :rparen}
  defp to_token("+"), do: %Token{type: :add}
  defp to_token("*"), do: %Token{type: :mul}
  defp to_token(i), do: %Token{type: :integer, value: String.to_integer(i)}
end

IO.inspect(AdventOfCode.TwentyTwenty.Eighteen.solve(System.argv()))
