defmodule RestApi.Repo.Migrations.AddUniqueIndexToUserTopicRelationships do
  use Ecto.Migration

  def change do
    create unique_index("user_topics_relationship", [:userId, :topicId])
  end
end
