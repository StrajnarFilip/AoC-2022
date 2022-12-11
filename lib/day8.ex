defmodule Day8 do
  alias JasonVendored.Encode

  def to_matrix(file_name) do
    Qik.parse(file_name, "\n", fn x -> String.graphemes(x) |> Enum.map(&String.to_integer(&1)) end)
  end

  def index_matrix(matrix) do
    column_indexes = Enum.count(Enum.at(matrix, 0))

    Qik.indexes(matrix)
    |> Enum.map(fn row -> 0..(column_indexes - 1) |> Enum.map(fn col -> [row, col] end) end)
  end

  def tree_largest_so_far?(matrix, row, col) do
    current_val = Enum.at(matrix, row) |> Enum.at(col)
    row_so_far = Enum.at(matrix, row) |> Enum.take(col)
    Enum.all?(row_so_far, fn element -> element < current_val end)
  end

  def visible_in_row(matrix, index_row) do
    index_row
    |> Enum.map(fn col ->
      [row_index, col_index] = col

      cond do
        Enum.any?(col, &(&1 == 0)) -> 1
        tree_largest_so_far?(matrix, row_index, col_index) -> 1
        true -> 0
      end
    end)
  end

  def visible_from_left(matrix) do
    matrix
    |> index_matrix()
    |> Enum.map(fn row -> visible_in_row(matrix, row) end)
  end

  def rotate270(matrix) do
    matrix
    |> rotate180()
    |> rotate90()
  end

  def rotate180(matrix) do
    matrix
    |> rotate90()
    |> rotate90()
  end

  def rotate90(matrix) do
    matrix
    |> Enum.reverse()
    |> Enum.zip_reduce([], fn els, acc -> [els | acc] end)
    |> Enum.reverse()
  end

  def accumulate_visibility(elements, accumulator) do
    visible =
      if Enum.any?(elements, fn el -> el > 0 end) do
        1
      else
        0
      end

    [visible | accumulator]
  end

  def visibility_matrix(tree_matrix) do
    # Visible from left
    m_left = tree_matrix |> visible_from_left()
    # Visible from down
    m_down = tree_matrix |> rotate90() |> visible_from_left() |> rotate270()
    # Visible from right
    m_right = tree_matrix |> rotate180() |> visible_from_left() |> rotate180()
    # Visible from up
    m_up = tree_matrix |> rotate270() |> visible_from_left() |> rotate90()

    Enum.zip_reduce([m_left, m_down, m_up, m_right], [], fn rows, acc ->
      visibility =
        rows
        |> Enum.zip_reduce([], &accumulate_visibility/2)
        # Reverse because cons
        |> Enum.reverse()

      [visibility | acc]
    end)
    # Reverse because cons
    |> Enum.reverse()
  end

  def solution1(file_name) do
    matrix =
      file_name
      |> to_matrix()

    matrix
    |> visibility_matrix()
    |> Enum.map(fn v -> Enum.sum(v) end)
    |> Enum.sum()
  end

  defp json_look(matrix) do
    a =
      matrix
      |> Enum.map(fn x -> Enum.join(x) end)
      |> JSON.encode()
      |> elem(1)

    File.write("ok.json", a)
  end

  def solution2(file_name) do
  end
end
