defmodule RestApiWeb.AdminView do
    use RestApiWeb, :view

    def render("event.json", %{event: event}) do
        event
    end
end