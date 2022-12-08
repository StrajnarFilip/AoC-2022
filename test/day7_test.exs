defmodule Day7Test do
  use ExUnit.Case
  import Day7

  test "Solution for part 1" do
    assert solution1("day7.txt") == 1390824
  end

  test "Solution for part 2" do
    assert solution2("day7.txt") == 7490863
  end
end
