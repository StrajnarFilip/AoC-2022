defmodule Day3 do
  def raw_data() do
    {:ok, data} = File.read("day3.txt")

    data
    |> String.split("\r\n")
  end

  def matching_item(pair) do
    {left, right} = pair

    String.graphemes(left)
    |> Enum.uniq()
    |> Enum.filter(fn x -> Enum.member?(String.graphemes(right), x) end)
    |> Enum.at(0)
  end

  def matching_item_in_group(chunk) do
    chunk
    |> Enum.at(0)
    |> String.graphemes
    |> Enum.uniq
    |> Enum.filter(fn grapheme -> Enum.all?(chunk,fn x -> Enum.member?(String.graphemes(x),grapheme) end) end)
    |> Enum.at(0)
  end

  def priority(grapheme) do
    <<code>> = grapheme

    if Regex.match?(~r/[A-Z]/, grapheme) do
      code - 38
    else
      code - 96
    end
  end

  def solution1 do
    raw_data()
    |> Enum.map(fn x -> String.split_at(x, div(String.length(x), 2)) end)
    |> Enum.map(&matching_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum
  end

  def solution2 do
    raw_data()
    |> Enum.chunk_every(3)
    |> Enum.map(&matching_item_in_group/1)
    |> Enum.map(&priority/1)
    |> Enum.sum
  end
end
