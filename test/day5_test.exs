defmodule Day5Test do
  use ExUnit.Case
  import Day5

  test "Solution for part 1" do
    assert solution1("day5.txt") == "TLNGFGMFN"
  end

  test "Solution for part 2" do
    assert solution2("day5.txt") == "FGLQJCMBD"
  end
end
