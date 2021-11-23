defmodule ReportsGeneratorTest do
  use ExUnit.Case

  doctest ReportsGenerator

  describe "build/1" do
    test "should returns a report with couting of foods and users passing the file name" do
      file_name = "report_test"

      response = ReportsGenerator.build(file_name)

      expected_response = %{
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

      assert response == expected_response
    end
  end

  describe "build_from_many/1" do
    test "should returns a report with couting of foods and users passing the file names" do
      file_names = ["report_test", "report_test"]

      response = ReportsGenerator.build_from_many(file_names)

      expected_response = %{
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

      assert response == expected_response
    end

    test "should returns a report a tuple of error and an error message when the passed parameter is not a list" do
      file_names = "banana"

      response = ReportsGenerator.build_from_many(file_names)

      expected_response = {:error, "Please, provide a list of strings!"}

      assert response == expected_response
    end
  end

  describe "fetch_higher_cost/1" do
    test "should returns the user with higher cost when passing 'users'" do
      file_name = "report_test"
      option = "foods"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(option)

      expected_response = {:ok, {"esfirra", 3}}

      assert response == expected_response
    end

    test "should returns error tupple with invalid option when passing a non existent option" do
      file_name = "report_test"
      option = "banana"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(option)

      expected_response = {:error, "Invalid option!"}

      assert response == expected_response
    end
  end
end
