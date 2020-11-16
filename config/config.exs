# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rest_api,
  ecto_repos: [RestApi.Repo]

config :rest_api, RestApi.Guardian,
  issues: "rest_api",
  secret_key: "Ehb/hqXICxV3z5xJroC++H9s9vhM5k9xJpWlD3fg5FECC+laHFBZER5fWS3vig3w"

# Configures the endpoint
config :rest_api, RestApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wCMvGRfjPrlp7DTRS1b/XERO6WoPb6wqmBakfsByeziPtC72nJy6xkeqhiAYJG3p",
  render_errors: [view: RestApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RestApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :basic_auth,
  my_auth: [
    username: "admin.email@gmail.com",
    password: "admin"
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
