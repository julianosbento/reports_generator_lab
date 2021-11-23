defmodule ReportsGenerator do
  @moduledoc """
  Documentation for `ReportsGenerator`.
  """

  @doc """
  Reports Generator module.

  ## Examples

      iex> ReportsGenerator.build("report_test")
      %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }


      iex> ["report_test", "report_test"] |> ReportsGenerator.build_from_many()
      %{
        "foods" => %{
          "açaí" => 2,
          "churrasco" => 4,
          "esfirra" => 6,
          "hambúrguer" => 4,
          "pastel" => 0,
          "pizza" => 4,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 96,
          "10" => 72,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 90,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 62,
          "30" => 0,
          "4" => 84,
          "5" => 98,
          "6" => 36,
          "7" => 54,
          "8" => 50,
          "9" => 48
        }
      }

      iex> "banana" |> ReportsGenerator.build_from_many()
      {:error, "Please, provide a list of strings!"}

      iex> "report_test" |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("foods")
      {:ok, {"esfirra", 3}}

      iex> "report_test" |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("banana")
      {:error, "Invalid option!"}
  """
  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["users", "foods"]

  def build(filename) do
    alias ReportsGenerator.Parser

    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(file_names) when not is_list(file_names) do
    {:error, "Please, provide a list of strings!"}
  end

  def build_from_many(file_names) do
    file_names
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)
  end

  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_id, value} -> value end)}
  end

  def fetch_higher_cost(_report, _option), do: {:error, "Invalid option!"}

  def fetch_higher_cost(report), do: Enum.max_by(report, fn {_id, value} -> value end)

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    build_report(foods, users)
  end

  defp sum_reports(%{"foods" => first_foods, "users" => first_users}, %{
         "foods" => second_foods,
         "users" => second_users
       }) do
    foods = merge_maps([first_foods, second_foods])
    users = merge_maps([first_users, second_users])

    build_report(foods, users)
  end

  defp merge_maps(lists),
    do:
      Enum.reduce(lists, fn element, acc ->
        Map.merge(acc, element, fn _key, acc_value, element_value -> acc_value + element_value end)
      end)

  defp build_report(foods, users), do: %{"foods" => foods, "users" => users}

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report(foods, users)
  end
end
