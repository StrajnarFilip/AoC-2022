defmodule Day3Test do
  use ExUnit.Case
  import Day3

  test "Solution for part 1" do
    assert solution1() == 8109
  end

  test "Solution for part 2" do
    assert solution2() == 2738
  end
end
