defmodule Day1 do
  def sorted_data() do
    {:ok, data} = File.read("day1.txt")

    data
    |> String.split("\r\n")
    |> Enum.chunk_by(&(String.length(&1) > 0))
    |> Enum.filter(fn x -> String.length(Enum.at(x, 0)) != 0 end)
    |> Enum.map(fn x -> Enum.sum(Enum.map(x, &String.to_integer(&1))) end)
    |> Enum.sort(&(&1 >= &2))
  end

  def get_max(input_data) do
    Enum.take(input_data, 1) |> Enum.sum()
  end

  def get_sum_max_3(input_data) do
    Enum.take(input_data, 3) |> Enum.sum()
  end

  def solution1() do
    sorted_data() |> get_max
  end

  def solution2() do
    sorted_data() |> get_sum_max_3
  end
end
