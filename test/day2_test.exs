defmodule Day2Test do
  use ExUnit.Case
  import Day2

  test "Solution for part 1" do
    assert solution1() == 9241
  end

  test "Solution for part 2" do
    assert solution2() == 14610
  end
end
