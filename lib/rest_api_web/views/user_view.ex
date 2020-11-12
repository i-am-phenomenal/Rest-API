defmodule RestApiWeb.UserView do
    use RestApiWeb, :view

    def render("user_sign_up.json", %{resp: resp}) do
        resp
        |> Map.from_struct()
        |> Map.drop([:__meta__, :topics_of_interests])
    end
  end
  
  