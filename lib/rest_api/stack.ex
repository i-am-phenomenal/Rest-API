defmodule Stack do
    use GenServer

    
    def startLink() do 
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

    def addValueAsync(processId, newValue) do
        GenServer.cast(processId, {:addNewElementAsync, newValue})
    end

    def popValueAsync(processId) do
        GenServer.cast(processId, :popValueAsync)
    end

    def deleteStack(processId) do
        GenServer.call(processId, :deleteStack)
    end

    def performOperations(processId) do
        GenServer.cast(processId, {:addNewElementAsync, 10})
        getCurrentState(processId)
        GenServer.cast(processId, {:addNewElementAsync, 20})
        getCurrentState(processId)
        GenServer.cast(processId, {:addNewElementAsync, 30})
        getCurrentState(processId)
        GenServer.cast(processId, {:addNewElementAsync, 40})
        getCurrentState(processId)
        GenServer.cast(processId, {:addNewElementAsync, 50})
        getCurrentState(processId)
    end

    #Callbacks
    @impl true
    def handle_cast({:addNewElementAsync, newElement}, currentState) do
        {:noreply,  [newElement] ++ currentState }
    end

    @impl true
    def handle_cast(:popValueAsync, currentState) do
        [head | tail] = currentState
        {:noreply, tail}
    end

    @impl true
    def handle_call(:deleteStack, _from, currentStack) do
        {:reply, [], []}
    end

    @impl true
    def handle_call(:getCurrentState, _, currentState) do
        IO.inspect(currentState, label: "CURRENT STATE -> ")
        {:reply, currentState, currentState}
    end

    @impl true
    def handle_call({:addNewElement, newElement}, _from , currentState) do
        updatedState = [newElement] ++ currentState
        {:reply, updatedState, updatedState}
    end

    @impl true
    def handle_call(:popElement, _from , currentState) do
        [head | tail] = currentState
        {:reply, tail, tail}
    end

    @impl true
    def handle_info(:info, currentState) do
        {:noreply, currentState}
    end
end