defmodule Functions do
  def count_xmas(file_content) do
    grid = make_grid(file_content)
    char_lists = extract_char_lists(grid, {0, 0})
    char_lists
    |> Enum.map(& check_if_xmas(&1))
    |> Enum.count(& &1)
  end

  def make_grid(file_content) do
    file_content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def extract_char_lists(grid, {x, y}) do
    char_lists =
      [
        extract_diagonal1(grid, {x, y}),
        extract_diagonal2(grid, {x, y}),
        extract_column(grid, {x, y}),
        extract_row(grid, {x, y})
      ]
      |> Enum.filter(& &1)
    max_x = get_width(grid) - 1
    max_y = get_height(grid) - 1
    case {x, y} do
      {^max_x, ^max_y} -> char_lists
      {^max_x, _} -> char_lists ++ extract_char_lists(grid, {0, y + 1})
      {_, _} -> char_lists ++ extract_char_lists(grid, {x + 1, y})
    end
  end

  def extract_diagonal1(grid, {x, y}) do
    case x <= get_width(grid) - 4 and y <= get_height(grid) - 4 do
      true -> [get_value(grid, x, y), get_value(grid, x + 1, y + 1), get_value(grid, x + 2, y + 2), get_value(grid, x + 3, y + 3)]
      false -> nil
    end
  end

  def extract_diagonal2(grid, {x, y}) do
    case x >= 3 and y <= get_height(grid) - 4 do
      true -> [get_value(grid, x, y), get_value(grid, x - 1, y + 1), get_value(grid, x - 2, y + 2), get_value(grid, x - 3, y + 3)]
      false -> nil
    end
  end

  def extract_column(grid, {x, y}) do
    case y <= get_height(grid) - 4 do
      true -> [get_value(grid, x, y), get_value(grid, x, y + 1), get_value(grid, x, y + 2), get_value(grid, x, y + 3)]
      false -> nil
    end
  end

  def extract_row(grid, {x, y}) do
    case x <= get_width(grid) - 4 do
      true -> [get_value(grid, x, y), get_value(grid, x + 1, y), get_value(grid, x + 2, y), get_value(grid, x + 3, y)]
      false -> nil
    end
  end

  def check_if_xmas(chars) do
    case chars do
      ~c"XMAS" -> true
      ~c"SAMX" -> true
      _ -> false
    end
  end

  def get_value(grid, x, y), do: grid |> Enum.at(y) |> Enum.at(x)

  def get_width(grid), do: Enum.count(Enum.at(grid, 0))

  def get_height(grid), do: Enum.count(grid)

  def count_x_mas(file_content) do
    grid = make_grid(file_content)
    char_lists = extract_char_lists2(grid, {0, 0})
    char_lists
    |> Enum.map(& check_if_x_mas(&1))
    |> Enum.count(& &1)
  end

  def extract_char_lists2(grid, {x, y}) do
    char_lists =
      [extract_x(grid, {x, y})]
      |> Enum.filter(& &1)
    max_x = get_width(grid) - 1
    max_y = get_height(grid) - 1
    case {x, y} do
      {^max_x, ^max_y} -> char_lists
      {^max_x, _} -> char_lists ++ extract_char_lists2(grid, {0, y + 1})
      {_, _} -> char_lists ++ extract_char_lists2(grid, {x + 1, y})
    end
  end

  def extract_x(grid, {x, y}) do
    case x >= 1 and x <= get_width(grid) - 2 and y >= 1 and y <= get_height(grid) - 2 do
      true -> [
        get_value(grid, x - 1, y - 1),
        get_value(grid, x + 1, y - 1),
        get_value(grid, x, y),
        get_value(grid, x - 1, y + 1),
        get_value(grid, x + 1, y + 1)
      ]
      false -> nil
    end
  end

  def check_if_x_mas(chars) do
    case chars do
      ~c"MMASS" -> true
      ~c"MSAMS" -> true
      ~c"SMASM" -> true
      ~c"SSAMM" -> true
      _ -> false
    end
  end

end

file_content = File.read!("4-input.txt")

number_of_xmas = file_content |> Functions.count_xmas
IO.puts "Number of XMAS: #{number_of_xmas}"

number_of_x_mas = file_content |> Functions.count_x_mas
IO.puts "Number of X-MAS: #{number_of_x_mas}"
