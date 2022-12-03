defmodule Day3 do
  def raw_data(file_name) do
    {:ok, data} = File.read(file_name)

    data
    |> String.split("\r\n")
  end

  def contains_grapheme?(text, grapheme), do: Enum.member?(String.graphemes(text), grapheme)

  def matching_item(pair) do
    {left, right} = pair

    String.graphemes(left)
    |> Enum.uniq()
    |> Enum.filter(&contains_grapheme?(right, &1))
    |> Enum.at(0)
  end

  def matching_item_in_group(chunk) do
    chunk
    |> Enum.at(0)
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.filter(fn grapheme -> Enum.all?(chunk, &contains_grapheme?(&1, grapheme)) end)
    |> Enum.at(0)
  end

  def priority(grapheme) do
    <<code>> = grapheme

    cond do
      Regex.match?(~r/[A-Z]/, grapheme) -> code - 38
      true -> code - 96
    end
  end

  def solution1(file_name) do
    raw_data(file_name)
    |> Enum.map(fn line -> String.split_at(line, div(String.length(line), 2)) end)
    |> Enum.map(&matching_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  def solution2(file_name) do
    raw_data(file_name)
    |> Enum.chunk_every(3)
    |> Enum.map(&matching_item_in_group/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end
end
