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
    get "/get_all_users", UserController, :getAllUsers
    get "/get_all_topics", TopicController, :getAllTopics
    post "/users/topic_of_interest/", UserController, :addTopicOfInterest
    get "/user/:user_id/topics_of_interests", TopicController, :getUsersTopicsOfInterests
    post "/add_topic", TopicController, :addNewTopicOfInterest
    delete "user/remove_topic_of_interest/", UserController, :removeUserAndTopicAssociation
  end

  # Other scopes may use custom stacks.
  # scope "/api", RestApiWeb do
  #   pipe_through :api
  # end
end
