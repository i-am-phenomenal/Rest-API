defmodule RestApiWeb.UserView do
    use RestApiWeb, :view

    def render("user_sign_up.json", %{resp: resp}) do
        resp
    end
  end
  