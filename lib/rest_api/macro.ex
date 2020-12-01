defmodule RestApi.Macro do
    alias RestApi.Repo    
    alias RestApi.TopicEventRelationship

    defmacro hasAllKeys?(params) do
        Map.has_key?(params, "topicName") and Map.has_key?(params, "shortDesc")
    end

    defmacro topicEventRelationshipDoesNotExist(val)  do
            quote do
                case val do 
                    nil -> true
                    val -> false 
                end
        end
    end

    # defmacro topicEventRelationshipDoesNotExist(val) when not is_nil(val) do
    #     quote do
    #         false
    #     end
    # end
end
