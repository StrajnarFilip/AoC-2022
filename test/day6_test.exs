defmodule Day6Test do
  use ExUnit.Case
  import Day6

  test "Solution for part 1" do
    assert solution1("day6.txt") == 1623
  end

  test "Solution for part 2" do
    assert solution2("day6.txt") == 3774
  end
end
