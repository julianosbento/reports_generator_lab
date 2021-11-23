defmodule ReportsGenerator.Parser do
  @moduledoc """
  Documentation for `ReportsGenerator`.
  """

  @doc """
  Reports Generator Parser module.

  ## Examples

      iex> ReportsGenerator.Parser.parse_file("report_test")
  """
  def parse_file(filename) do
    "reports/#{filename}.csv"
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end
end
