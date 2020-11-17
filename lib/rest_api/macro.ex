defmodule RestApi.Macro do

    defmacro hasAllKeys?(params) do
        Map.has_key?(params, "topicName") and Map.has_key?(params, "shortDesc")
    end
end