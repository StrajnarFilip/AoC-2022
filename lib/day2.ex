defmodule Day2 do
  def raw_data() do
    {:ok, data} = File.read("day2.txt")

    data
    |> String.split("\r\n")
    |> Enum.map(fn pair -> String.split(pair, " ") end)
  end

  defp check_win(choice) do
    case choice do
      %{:first => :scissors, :second => :paper} -> true
      %{:first => :rock, :second => :scissors} -> true
      %{:first => :paper, :second => :rock} -> true
      _ -> false
    end
  end

  defp translate1(choice) do
    case choice do
      "X" -> :rock
      "Y" -> :paper
      "Z" -> :scissors
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
    end
  end

  defp translate2(choice) do
    case choice do
      "X" -> :loss
      "Y" -> :draw
      "Z" -> :win
    end
  end

  defp choose_win(choice) do
    case choice do
      :rock -> :paper
      :paper -> :scissors
      :scissors -> :rock
    end
  end

  def outcome_points(pair) do
    cond do
      check_win(%{:first => pair.me, :second => pair.opponent}) -> 6
      check_win(%{:first => pair.opponent, :second => pair.me}) -> 0
      true -> 3
    end
  end

  def shape_points(data) do
    case data.me do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  def solution1() do
    raw_data()
    |> Enum.map(fn pair ->
      %{:opponent => Enum.at(pair, 0) |> translate1, :me => Enum.at(pair, 1) |> translate1}
    end)
    |> Enum.map(fn pair -> outcome_points(pair) + shape_points(pair) end)
    |> Enum.sum()
  end

  def solution2() do
    raw_data()
    |> Enum.map(fn pair ->
      %{:opponent => Enum.at(pair, 0) |> translate1, :outcome => Enum.at(pair, 1) |> translate2}
    end)
    |> Enum.map(fn pair ->
      case pair.outcome do
        :loss -> %{:opponent => pair.opponent, :me => pair.opponent |> choose_win |> choose_win}
        :draw -> %{:opponent => pair.opponent, :me => pair.opponent}
        :win -> %{:opponent => pair.opponent, :me => pair.opponent |> choose_win}
      end
    end)
    |> Enum.map(fn pair -> outcome_points(pair) + shape_points(pair) end)
    |> Enum.sum()
  end
end
