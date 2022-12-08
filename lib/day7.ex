defmodule Day7 do
  @spec generate_tree(list(), map() | nil, list(binary())) :: map()
  def generate_tree(commands, tree \\ %{"name" => "/", "dirs" => %{}}, pwd \\ []) do
    if Enum.empty?(commands) do
      tree
    else
      [data | tail] = commands
      command = Enum.at(data, 0) |> String.split(" ")

      case Enum.at(command, 0) do
        "cd" -> generate_tree(tail, tree, new_path(pwd, Enum.at(command, 1)))
        "ls" -> generate_tree(tail, parse_ls(tree, data, pwd), pwd)
      end
    end
  end

  @spec to_node(map(), list(binary())) :: map()
  def to_node(tree, to) do
    if Enum.empty?(to) do
      tree
    else
      [head | tail] = to

      Map.get(tree, "dirs")
      |> Map.get(head)
      |> to_node(tail)
    end
  end

  @spec replace_node(map(), list(binary()), map()) :: map()
  def replace_node(tree, to, update) do
    if Enum.empty?(to) do
      update
    else
      [head | tail] = to

      Map.update(tree, "dirs", %{}, fn dirs ->
        Map.update(dirs, head, %{}, fn existing_dir ->
          replace_node(existing_dir, tail, update)
        end)
      end)
    end
  end

  @spec parse_ls(map(), list(), list(binary())) :: map()
  def parse_ls(tree, data, pwd) do
    result = Enum.drop(data, 1)

    replace_node(tree, pwd, %{
      "name" => List.last(pwd, "/"),
      "dirs" => parse_dirs(result) |> dirs_to_map(),
      "files" => parse_files(result),
      "file_sum" =>
        parse_files(result)
        |> Enum.map(fn file -> Map.get(file, "size") |> String.to_integer() end)
        |> Enum.sum()
    })
  end

  @spec parse_files(list(binary())) :: list(map())
  def parse_files(output) do
    output
    |> Enum.filter(fn line -> !String.starts_with?(line, "dir") end)
    |> Enum.map(fn line ->
      [size, name] = String.split(line, " ")
      %{"size" => size, "name" => name}
    end)
  end

  def update_dir(dir) do
    dir_handled = directory_sizes(dir)
    dir_size = Map.get(dir_handled, "dir_size")
    updated_dirs = Map.get(dir_handled, "dirs")

    Map.put(dir, "dir_size", dir_size)
    |> Map.update("dirs", updated_dirs, fn _ -> updated_dirs end)
  end

  def update_keys(dirs, keys) do
    if Enum.empty?(keys) do
      dirs
    else
      [head | tail] = keys
      updated_dirs = Map.update(dirs, head, :error, &update_dir(&1))
      update_keys(updated_dirs, tail)
    end
  end

  @spec directory_sizes(map()) :: map()
  def directory_sizes(tree) do
    dirs = Map.get(tree, "dirs")
    keys = Map.keys(dirs)
    file_sum = Map.get(tree, "file_sum")

    # If this node has no more directories inside it
    if Enum.empty?(keys) do
      # Return file_sum as dir_size, since files represent all it's size
      Map.put(tree, "dir_size", file_sum)
    else
      # Recursively update each key of this node's dirs map
      updated = update_keys(dirs, keys)
      # IO.inspect(updated)

      # Make a new treem with dirs replaced with ones that have dir_size information
      updated_dirs = Map.update(tree, "dirs", updated, fn _ -> updated end)

      sum =
        keys |> Enum.map(fn key -> Map.get(Map.get(updated, key), "dir_size") end) |> Enum.sum()

      Map.put(updated_dirs, "dir_size", file_sum + sum)
    end
  end

  @spec parse_dirs(list(binary())) :: list()
  def parse_dirs(output) do
    output
    |> Enum.filter(fn line -> String.starts_with?(line, "dir") end)
    |> Enum.map(fn line -> String.split(line, " ") |> Enum.at(1) end)
  end

  def dirs_to_map(dirs, map \\ %{}) do
    if Enum.empty?(dirs) do
      map
    else
      [head | tail] = dirs
      dirs_to_map(tail, Map.put(map, head, %{"dirs" => %{}}))
    end
  end

  @spec new_path(list(binary()), binary()) :: list(binary())
  def new_path(current_path, cd_to) do
    case cd_to do
      ".." -> List.pop_at(current_path, -1) |> elem(1)
      "/" -> []
      _ -> List.insert_at(current_path, -1, cd_to)
    end
  end

  def split_and_trim(command), do: String.split(command, "\n") |> Enum.map(&String.trim/1)
  def filter_empty_strings(command), do: Enum.filter(command, &(String.length(&1) != 0))

  def parse_commands(file_name) do
    Qik.parse(file_name, "$", &split_and_trim/1)
    |> Enum.map(&filter_empty_strings/1)
    |> Enum.filter(&(Enum.count(&1) != 0))
  end

  def find_condition_keys(dirs, condition, keys, acc) do
    if Enum.empty?(keys) do
      acc
    else
      [head | tail] = keys
      new_acc = find_condition(Map.get(dirs, head), condition, acc)
      find_condition_keys(dirs, condition, tail, new_acc)
    end
  end

  def find_condition(tree, condition, acc \\ []) do
    dirs = Map.get(tree, "dirs")
    keys = Map.keys(dirs)
    dir_size = Map.get(tree, "dir_size")

    new_acc =
      if condition.(dir_size) do
        [%{name: Map.get(tree, "name"), dir_size: dir_size} | acc]
      else
        acc
      end

    if Enum.empty?(keys) do
      new_acc
    else
      find_condition_keys(dirs, condition, keys, new_acc)
    end
  end

  def sized_directories(file_name),
    do: parse_commands(file_name) |> generate_tree() |> directory_sizes()

  def solution1(file_name) do
    sized_directories(file_name)
    |> find_condition(fn x -> x <= 100_000 end)
    |> Enum.map(fn x -> x.dir_size end)
    |> Enum.sum()
  end

  def solution2(file_name) do
    total_space = 70_000_000
    needed_space = 30_000_000

    used_space =
      sized_directories(file_name)
      |> Map.get("dir_size")

    min_dir_size = needed_space - (total_space - used_space)
    parse_commands(file_name)
    |> generate_tree()
    |> directory_sizes()
    |> find_condition(fn x -> x >= min_dir_size end)
    |> Enum.map(fn x -> x.dir_size end)
    |> Enum.min()
  end
end
