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

    def render("users_for_event.json", %{users: users}) do
        users
        |> Enum.map(fn user -> 
            %{
                fullName: user.fullName,
                emailId: user.email,
                age: user.age
            }
        end)
    end
end