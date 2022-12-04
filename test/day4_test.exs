defmodule Day4Test do
    use ExUnit.Case
    import Day4
  
    test "Solution for part 1" do
      assert solution1("day4.txt") == 526
    end
  
    test "Solution for part 2" do
      assert solution2("day4.txt") == 886
    end
  end
  