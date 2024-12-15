defmodule Functions do
  def levels_are_increasing(report) do
    case report do
      [] -> true
      [_] -> true
      [first | rest] -> first < hd(rest) and Functions.levels_are_increasing(rest)
    end
  end

  def levels_are_decreasing(report) do
    case report do
      [] -> true
      [_] -> true
      [first | rest] -> first > hd(rest) and Functions.levels_are_decreasing(rest)
    end
  end

  def adjacent_levels_are_close(report, min, max) do
    case report do
      [] -> true
      [_] -> true
      [first | rest] -> abs(first - hd(rest)) >= min and
        abs(first - hd(rest)) <= max and
        Functions.adjacent_levels_are_close(rest, min, max)
    end
  end

  def is_safe(report) do
    (Functions.levels_are_decreasing(report) or Functions.levels_are_increasing(report)) and
      Functions.adjacent_levels_are_close(report, 1, 3)
  end

  def get_reports_with_one_level_removed(report, level_to_remove) do
    case level_to_remove == Enum.count(report) - 1 do
      true -> [Enum.slice(report, 0, level_to_remove)]
      false -> [
        Enum.slice(report, 0, level_to_remove) ++
        Enum.slice(report, level_to_remove + 1, Enum.count(report) - level_to_remove - 1)
      ] ++ Functions.get_reports_with_one_level_removed(report, level_to_remove + 1)
    end
  end

  def is_safe_when_tolerating_one_bad_level(report) do
    Functions.get_reports_with_one_level_removed(report, 0)
    |> Enum.map(&Functions.is_safe/1)
    |> Enum.any?
  end
end

content = File.read!("2-input.txt")

reports = content
|> String.split("\n")
|> Enum.map(fn line ->
  line
  |> String.split
  |> Enum.map(&String.to_integer/1)
end)
|> Enum.drop(-1)

number_of_safe_reports = reports
|> Enum.filter(&Functions.is_safe/1)
|> Enum.count

IO.puts "Number of safe reports: #{number_of_safe_reports}"

number_of_safe_reports_when_tolerating_a_single_bad_level = reports
|> Enum.filter(&Functions.is_safe_when_tolerating_one_bad_level/1)
|> Enum.count

IO.puts "Number of safe reports when tolerating a single bad level: #{number_of_safe_reports_when_tolerating_a_single_bad_level}"
