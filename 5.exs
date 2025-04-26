defmodule Functions do
  def sum_middle_page_numbers(file_content) do
    rules = get_page_ordering_rules(file_content)
    updates = get_pages_to_produce_in_each_update(file_content)
    correct_updates = get_correctly_ordered_updates(updates, rules)
    middle_page_numbers = get_middle_page_numbers(correct_updates)
    Enum.sum(middle_page_numbers)
  end

  def get_page_ordering_rules(file_content) do
    file_content
    |> String.split("\n")
    |> Enum.take_while(&(&1 != ""))
    |> Enum.map(&(String.split(&1, "|")))
    |> Enum.map(&({String.to_integer(Enum.at(&1, 0)), String.to_integer(Enum.at(&1, 1))}))
  end

  def get_pages_to_produce_in_each_update(file_content) do
    file_content
    |> String.split("\n")
    |> Enum.drop_while(&(&1 != ""))
    |> tl()
    |> Enum.take_while(&(&1 != ""))
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_correctly_ordered_updates(updates, rules) do
    updates
    |> Enum.filter(&(is_update_correctly_ordered(&1, rules)))
  end

  def is_update_correctly_ordered([], _rules), do: true
  def is_update_correctly_ordered([_single], _rules), do: true
  def is_update_correctly_ordered(update, rules) do
    is_first_page_correct = update
    |> tl
    |> Enum.all?(&({hd(update), &1} in rules))
    is_first_page_correct and is_update_correctly_ordered(tl(update), rules)
  end

  def get_middle_page_numbers(updates) do
    updates
    |> Enum.map(&get_middle_page_number/1)
  end

  def get_middle_page_number(update), do: Enum.at(update, div(length(update) - 1, 2))
end

file_content = File.read!("5-input.txt")

sum = file_content |> Functions.sum_middle_page_numbers
IO.puts "Middle page number sum: #{sum}"
