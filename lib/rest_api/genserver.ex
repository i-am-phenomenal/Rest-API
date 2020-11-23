defmodule Stack do
    use GenServer

    @impl true
    def start_link do 
        GenServer.start_link(Stack, [])
    end

    @impl true
    def init(initialState) do
        {:ok, initialState}
    end

    def getCurrentState(processId) do
        GenServer.call(processId, :getCurrentState)
    end

    def addNewValueToStack(processId, newValue) do
        GenServer.call(processId, {:addNewElement, newValue})
    end

    def pop(processId) do
        GenServer.call(processId, :popElement)
    end


    #Callbacks
    @impl true
    def handle_call(:getCurrentState, _, currentState) do
        {:reply, currentState, currentState}
    end

    @impl true
    def handle_call({:addNewElement, newElement}, _from , currentState) do
        updatedState = currentState ++ [newElement]
        {:reply, updatedState, updatedState}
    end

    @impl true
    def handle_call(:popElement, _from , currentState) do
        [head | tail] = currentState
        {:reply, tail, tail}
    end
end