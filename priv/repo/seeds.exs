# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RestApi.Repo.insert!(%RestApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RestApi.TopicsOfInterests
alias RestApi.Repo

topicNames = [
    "Sports",
    "Cars",
    "Reading",
    "Gaming",
    "Photography",
    "Music",
    "Travelling",
    "Fitness",
    "Healthcare",
    "Gardening",
    "Social work",
    "Humor",
    "Journaling",
    "Juggling",
    "Candy Making",
    "Cleaning",
    "Sewing",
    "Skeying",
    "Acting",
    "Filmmaking"
]

topicNames
|> Enum.map(fn topicName -> 
    changeset = TopicsOfInterests.changeset(%TopicsOfInterests{}, %{
        topicName: topicName,
        shortDesc: ""
    })
    Repo.insert(changeset)
end)

IO.puts("Inserted records ")