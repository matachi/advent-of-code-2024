defmodule Functions do
  def calculate_visited_cells(file_content) do
    grid = make_grid(file_content)
    finished_grid = move_guard(grid)
    IO.inspect(finished_grid, limit: :infinity)
    count_visited_cells(finished_grid)
  end

  def make_grid(file_content) do
    file_content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def count_visited_cells(grid) do
    grid
    |> List.flatten()
    |> Enum.count(&(&1 == ?X))
  end

  def move_guard(grid) do
    {x, y} = get_coordinate_of_guard(grid)
    if is_at_edge(grid, {x, y}) do
      grid |> set_value_at_coordinate({x, y}, ?X)
    else
      value = get_value_at_coordinate(grid, {x, y})
      is_at_wall =
        value == ?< and get_value_at_coordinate(grid, {x - 1, y}) == ?# or
        value == ?> and get_value_at_coordinate(grid, {x + 1, y}) == ?# or
        value == ?^ and get_value_at_coordinate(grid, {x, y - 1}) == ?# or
        value == ?v and get_value_at_coordinate(grid, {x, y + 1}) == ?#
      grid = set_value_at_coordinate(grid, {x, y}, ?X)
      case {is_at_wall, value} do
        {false, ?<} -> grid |> set_value_at_coordinate({x - 1, y}, ?<) |> move_guard
        {false, ?>} -> grid |> set_value_at_coordinate({x + 1, y}, ?>) |> move_guard
        {false, ?^} -> grid |> set_value_at_coordinate({x, y - 1}, ?^) |> move_guard
        {false, ?v} -> grid |> set_value_at_coordinate({x, y + 1}, ?v) |> move_guard
        {true, ?<} -> grid |> set_value_at_coordinate({x, y}, ?^) |> move_guard
        {true, ?>} -> grid |> set_value_at_coordinate({x, y}, ?v) |> move_guard
        {true, ?^} -> grid |> set_value_at_coordinate({x, y}, ?>) |> move_guard
        {true, ?v} -> grid |> set_value_at_coordinate({x, y}, ?<) |> move_guard
      end
    end
  end

  def is_at_edge(grid, {x, y}) do
    value = get_value_at_coordinate(grid, {x, y})
    last_x = get_width(grid) - 1
    last_y = get_height(grid) - 1
    case {x, y} do
      {0, _} when value == ?< -> true
      {_, 0} when value == ?^ -> true
      {^last_x, _} when value == ?> -> true
      {_, ^last_y} when value == ?v -> true
      _ -> false
    end
  end

  def get_coordinate_of_guard(grid), do: get_coordinate_of_guard(grid, {0, 0})

  def get_coordinate_of_guard(grid, {x, y}) do
    if x >= get_width(grid) do
      get_coordinate_of_guard(grid, {0, y + 1})
    else
      value = get_value_at_coordinate(grid, {x, y})
      case value do
        z when z in [?<, ?>, ?v, ?^] -> {x, y}
        _ -> get_coordinate_of_guard(grid, {x + 1, y})
      end
    end
  end

  def get_height(grid), do: grid |> length

  def get_width(grid), do: grid |> Enum.at(0) |> length

  def get_value_at_coordinate(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  def set_value_at_coordinate(grid, {x, y}, value) do
    List.replace_at(grid, y, List.replace_at(Enum.at(grid, y), x, value))
  end
end

file_content = File.read!("6-input.txt")
sum = file_content |> Functions.calculate_visited_cells
IO.puts "Number of visited cells: #{sum}"
