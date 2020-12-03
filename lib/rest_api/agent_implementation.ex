defmodule Counter do
    use Agent

    def start_link(initial_state) do
        {:ok, process_id} =  Agent.start_link(fn -> initial_state end, name: __MODULE__)
        process_id
    end

    def get_value do
        Agent.get(__MODULE__, & &1)
    end

    def add_value_to_counter do
        Agent.update(__MODULE__, &(&1 + 1))
    end

    def stop_agent do
        Agent.stop(__MODULE__)
    end

    """
        Implementation using Process Id 
    """
    
    def start_agent(initial_state) do
        Agent.start_link(fn -> initial_state end)
    end

    def get(process_id) do
        Agent.get(process_id, & &1)
    end

    def add(process_id) do
        Agent.update(process_id, &(&1 + 1))
    end

    def stop(process_id) do
        Agent.stop(process_id)
    end
end