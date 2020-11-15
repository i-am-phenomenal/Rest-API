defmodule RestApiWeb.EventView do
    use RestApiWeb, :view

    def render("rsvp_count.json", %{count: count}) do
        %{
            rsvp_count: count
        }
    end

    def render("cancelled_rsvp_count.json", %{count: count}) do
        %{
            cancelled_rsvp_count: count
        }
    end
end