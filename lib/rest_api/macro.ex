defmodule RestApi.Macro do
    alias RestApi.Repo    
    alias RestApi.TopicEventRelationship

    # Not a use case for Macro

    # defmacro hasAllKeys?(params) do
    #     Map.has_key?(params, "topicName") and Map.has_key?(params, "shortDesc")
    # end

    # defmacro topicEventRelationshipDoesNotExist(val) when is_nil(val)  do
    #         quote do
    #             true
    #     end
    # end

    # defmacro topicEventRelationshipDoesNotExist(val) when not is_nil(val) do
    #     quote do
    #         false
    #     end
    # end
end
