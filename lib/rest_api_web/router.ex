defmodule RestApiWeb.Router do
  use RestApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :auth do
    plug RestApi.Pipeline
    plug :print_hello
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug RestApi.Plug.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth do
    plug BasicAuth, [use_config: {:basic_auth, :my_auth}]
  end

  scope "/", RestApiWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    # get "/login", SessionController,  :new
    post "/login", SessionController, :login
    post "/sign_up", UserController, :signUp

  end

  scope "api/admin/", RestApiWeb do
    pipe_through [:browser, :basic_auth]
    # post "/login", AdminController, :adminLogin
    post "event/add", AdminController, :addNewEvent
    get "event/list/", AdminController, :listAllEvents
    put "event/update", AdminController, :updateAnEvent
    delete "event/delete", AdminController, :deleteAnEvent
    
    post "topic/add", AdminController, :addTopicOfInterest
    put "topic/update", AdminController, :updateTopicOfInterest
    get "topic/list", AdminController, :getAllTopics
    delete "topic/delete", AdminController, :deleteTopicOfInterest

    # resources "/topic_event", AdminTopicEventController, only: [:create, :index, :show]
    post "/topic_event/create", AdminTopicEventController, :create
    get "topic_event/get_all/", AdminTopicEventController, :index
    get "/topic_event/get_specific", AdminTopicEventController, :show
    delete "/topic_event/delete", AdminTopicEventController, :delete
    delete "topic_event/update", AdminTopicEventController, :update
  end
  

  scope "/api/v1", RestApiWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "protected", PageController, :protected
    get "get_all_users", UserController, :getAllUsers
    get "get_all_topics", TopicController, :getAllTopics
    put "user/update", UserController, :updateCurrentUserDetails
    put "update_user", UserController, :updateUserDetails
    delete "delete_user/", UserController, :deleteUserByEmailId
    post "users/topic_of_interest/", UserController, :addTopicOfInterest
    get "user/:user_id/topics_of_interests", TopicController, :getUsersTopicsOfInterests
    post "add_topic", TopicController, :addNewTopicOfInterest
    delete "user/remove_topic_of_interest/", UserController, :removeUserAndTopicAssociation

    get "event/rsvp_counts/:event_name_or_id", EventController, :getRSVPCountsForAnEvent
    get "event/rsvp_cancelled_counts/:event_name_or_id", EventController, :getCancelledRSVPCountsForEvent
    post "user/add_user_to_event/", EventController, :addUserToEvent
    post "user/remove_user_from_event/", EventController, :removeUserFromEvent
    delete "user/events/remove", EventController, :removeCurrentUserFromEvent
    get "events/users/list/:event_name_or_id", EventController, :listInterestedUsersForEvent
    get "events/cancelled_users/list/:event_name_or_id", EventController, :listOfCancelledUsersForEvent
    get "user/calendar/:email", UserController, :getListOfEventsForUser
    get "user/my_events/", UserController, :listMyevents
    post "user/add_event_to_my_list/", UserController, :addEventToMyList
    get "user/get_my_topics/", TopicController, :getCurrentUserTopicsOfInterests
    post "user/add_topic/:topic_name_or_id", TopicController, :addTopicOfInterestForCurrentUser
    post "user/testFunction", UserController, :testFunction

    post "topic_event/my_events", TopicEventController , :addUserTopicToEvent
  end

  
  defp print_hello(conn, opts) do
    IO.inspect("HELLOO 111111111111111111111111111")
    conn
  end
end
