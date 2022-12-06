defmodule Day6 do
  import Enum

  def input(file_name), do: File.read(file_name) |> elem(1) |> String.graphemes()

  def find_offset(chars, distinct \\ 4),
    do:
      (chars |> chunk_every(distinct, 1) |> find_index(&(uniq(&1) |> count() == distinct))) +
        distinct

  def solution1(file_name), do: file_name |> input |> find_offset

  def solution2(file_name), do: file_name |> input |> find_offset(14)
end
