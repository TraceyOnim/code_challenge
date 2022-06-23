defmodule BUR.ResponseTest do
  use ExUnit.Case, async: true
  alias BUR.Response

  @table :response

  test "user reaction can be created" do
    params = %{
      "type" => "reaction",
      "content_id" => "123",
      "user_id" => 4,
      "reaction_type" => "fire",
      "action" => "add"
    }

    Response.create_response(@table, params)

    assert [{"123", %Response{}}] = Response.get_response(@table, "123")
  end

  test "content_reaction_count/2 returns the count of unique users that added fire reaction and didn't remove" do
    param_1 = %{
      "type" => "reaction",
      "content_id" => "1234",
      "user_id" => 4,
      "reaction_type" => "fire",
      "action" => "add"
    }

    param_2 = %{
      "type" => "reaction",
      "content_id" => "1234",
      "user_id" => 4,
      "reaction_type" => "fire",
      "action" => "remove"
    }

    param_3 = %{
      "type" => "reaction",
      "content_id" => "1234",
      "user_id" => 5,
      "reaction_type" => "fire",
      "action" => "add"
    }

    for param <- [param_1, param_2, param_3] do
      Response.create_response(@table, param)
    end

    assert {:ok, %{content_id: "1234", reaction_count: %{fire: 1}}} =
             Response.content_reaction_count(@table, "1234")
  end

  test "content_reaction_count/2 returns an error if the content_id doesn't exist" do
    assert {:error, :not_found} = Response.content_reaction_count(@table, "12345")
  end
end
