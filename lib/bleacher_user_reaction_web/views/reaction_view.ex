defmodule BURWeb.ReactionView do
  use BURWeb, :view

  def render("show.json", %{result: result}) do
    result
  end
end
