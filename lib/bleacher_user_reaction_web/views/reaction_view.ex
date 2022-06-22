defmodule BURWeb.ReactionView do
  use BURWeb, :view

  def render("show.json", %{params: params}) do
    %{params: params}
  end
end
