defmodule Day1Test do
  use ExUnit.Case
  import Day1

  test "Solution for part 1" do
    assert solution1("day1.txt") == 74_394
  end

  test "Solution for part 2" do
    assert solution2("day1.txt") == 212_836
  end
end
