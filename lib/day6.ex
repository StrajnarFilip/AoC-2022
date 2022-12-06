defmodule Day6 do
  import Enum

  def input(file_name), do: File.read(file_name) |> elem(1) |> String.graphemes()

  def start(chars, n), do: (chars |> chunk_every(n, 1) |> find_index(&(count(uniq(&1)) == n))) + n

  def solution1(file_name), do: file_name |> input |> start(4)

  def solution2(file_name), do: file_name |> input |> start(14)
end
