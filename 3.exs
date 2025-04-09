defmodule Functions do
  @mul_operation_pattern ~r/^mul\((\d{1,3}),(\d{1,3})\)/
  @do_operation_pattern ~r/^do\(\)/
  @dont_operation_pattern ~r/^don't\(\)/

  def parse(""), do: 0

  def parse(string) do
    result = case extract_operation string do
      {:mul, arg1, arg2} -> arg1 * arg2
      _ -> 0
    end
    rest = parse(remove_first_character(string))
    result + rest
  end

  def parse("", _), do: 0

  def parse(string, enable) do
    operation = extract_operation string
    enable = case operation do
      :do -> 1
      :dont -> 0
      _ -> enable
    end
    result = case operation do
      {:mul, arg1, arg2} -> enable * arg1 * arg2
      _ -> 0
    end
    rest = parse(remove_first_character(string), enable)
    result + rest
  end

  def extract_operation(string) do
    case Regex.run(@mul_operation_pattern, string) do
      [_, arg1, arg2] -> {:mul, arg1 |> String.to_integer, arg2 |> String.to_integer}
      _ -> case Regex.run(@do_operation_pattern, string) do
        [_] -> :do
        _ -> case Regex.run(@dont_operation_pattern, string) do
          [_] -> :dont
          _ -> :error
        end
      end
    end
  end

  def remove_first_character(string), do: String.slice(string, 1, String.length(string) - 1)
end

content = File.read!("3-input.txt")

sum_of_operations = content |> Functions.parse
IO.puts "Sum of operations: #{sum_of_operations}"

sum_of_operations_with_enable = Functions.parse(content, 1)
IO.puts "Sum of operations: #{sum_of_operations_with_enable}"
