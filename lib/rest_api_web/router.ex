defmodule RestApiWeb.Router do
  use RestApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RestApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/", RestApiWeb do
    # pipe_through :browser
    post "/sign_up", UserController, :signUp
    post "/users/:user_id/topic_of_interest/", UserController, :addTopicOfInterest
  end

  # Other scopes may use custom stacks.
  # scope "/api", RestApiWeb do
  #   pipe_through :api
  # end
end
