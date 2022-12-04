defmodule Day4 do
  def data(file_name) do
    {:ok, raw_data} = File.read(file_name)

    raw_data
    |> String.split("\r\n")
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer(&1)) end)
    end)
  end

  def containsother?(line) do
    [range1, range2] = line
    [range1min, range1max] = range1
    [range2min, range2max] = range2

    (range1min >= range2min and range1max <= range2max) or
      (range1min <= range2min and range1max >= range2max)
  end

  def overlapsother?(line) do
    [list1, list2] = line
    range1 = Enum.at(list1, 0)..Enum.at(list1, 1)
    range2 = Enum.at(list2, 0)..Enum.at(list2, 1)

    Enum.any?(range2, fn element -> Enum.member?(range1, element) end)
  end

  def solution1(file_name) do
    data(file_name)
    |> Enum.filter(&containsother?/1)
    |> Enum.count()
  end

  def solution2(file_name) do
    data(file_name)
    |> Enum.filter(&overlapsother?/1)
    |> Enum.count()
  end
end
