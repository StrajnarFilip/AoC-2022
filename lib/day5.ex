defmodule Day5 do
  def raw_data(file_name), do: File.read(file_name) |> elem(1)

  def initial_state(file_name) do
    crate_lines =
      raw_data(file_name)
      |> String.split("\r\n\r\n")
      |> List.first()
      |> String.split("\r\n")

    line_length = crate_lines |> Enum.at(0) |> String.length()
    line_graphemes = crate_lines |> Enum.map(&String.graphemes(&1))
    last_line = line_graphemes |> Enum.at(Enum.count(crate_lines) - 1)
    last_index = line_length - 1

    valid_indices =
      0..last_index
      |> Enum.filter(fn index -> String.match?(Enum.at(last_line, index), ~r/[0-9]/) end)

    full_data =
      line_graphemes
      |> Enum.map(fn line -> String.graphemes(get_chars(line, valid_indices)) end)

    last_valid_index = Enum.count(Enum.at(full_data, 0)) - 1

    0..last_valid_index
    |> Enum.map(&get_column(full_data, &1))
  end

  defp get_chars(graphemes, indexes) do
    if Enum.empty?(indexes) do
      ""
    else
      [head | tail] = indexes
      Enum.at(graphemes, head) <> get_chars(graphemes, tail)
    end
  end

  defp get_column(full_data, column_index) do
    full_data
    |> Enum.map(fn line -> Enum.at(line, column_index) end)
    |> Enum.reverse()
    |> Enum.filter(&(&1 != " "))
  end

  def instructions(file_name) do
    raw_data(file_name)
    |> String.split("\r\n\r\n")
    |> Enum.at(1)
    |> String.split("\r\n")
    |> Enum.map(fn line ->
      split =
        String.split(line, " ")
        |> Enum.filter(fn x -> String.match?(x, ~r/[0-9]/) end)
        |> Enum.map(fn x -> String.to_integer(x) end)

      %{
        move: Enum.at(split, 0),
        from: Enum.at(split, 1),
        to: Enum.at(split, 2)
      }
    end)
  end

  def move(full_data, instruction) do
    if instruction.move == 0 do
      full_data
    else
      old_from =
        full_data
        |> Enum.filter(fn x -> String.to_integer(Enum.at(x, 0)) == instruction.from end)
        |> List.first()

      old_to =
        full_data
        |> Enum.filter(fn x -> String.to_integer(Enum.at(x, 0)) == instruction.to end)
        |> List.first()

      {element, new_from} = List.pop_at(old_from, -1)
      new_to = List.insert_at(old_to, -1, element)

      new_full_data =
        full_data
        |> Enum.map(fn line ->
          cond do
            String.to_integer(Enum.at(line, 0)) == instruction.to -> new_to
            String.to_integer(Enum.at(line, 0)) == instruction.from -> new_from
            true -> line
          end
        end)

      new_move = instruction.move - 1

      move(new_full_data, %{
        move: new_move,
        from: instruction.from,
        to: instruction.to
      })
    end
  end

  def move_multiple(full_data, instruction) do
    old_from =
      full_data
      |> Enum.filter(fn x -> String.to_integer(Enum.at(x, 0)) == instruction.from end)
      |> List.first()

    old_to =
      full_data
      |> Enum.filter(fn x -> String.to_integer(Enum.at(x, 0)) == instruction.to end)
      |> List.first()

    moving_pile = Enum.drop(old_from, Enum.count(old_from) - instruction.move)
    new_from = Enum.take(old_from, Enum.count(old_from) - instruction.move)
    new_to = old_to ++ moving_pile

    full_data
    |> Enum.map(fn line ->
      cond do
        String.to_integer(Enum.at(line, 0)) == instruction.to -> new_to
        String.to_integer(Enum.at(line, 0)) == instruction.from -> new_from
        true -> line
      end
    end)
  end

  def apply_instructions(full_data, instructions, multiple \\ false) do
    if Enum.empty?(instructions) do
      full_data
    else
      [head | tail] = instructions

      cond do
        multiple -> apply_instructions(move_multiple(full_data, head), tail, multiple)
        true -> apply_instructions(move(full_data, head), tail)
      end
    end
  end

  def solution1(file_name) do
    apply_instructions(initial_state(file_name), instructions(file_name))
    |> Enum.map(fn x -> Enum.at(x, -1) end)
    |> Enum.join("")
  end

  def solution2(file_name) do
    apply_instructions(initial_state(file_name), instructions(file_name), true)
    |> Enum.map(fn x -> Enum.at(x, -1) end)
    |> Enum.join("")
  end
end
