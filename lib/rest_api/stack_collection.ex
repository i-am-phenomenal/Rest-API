defmodule StackCollection do
    use GenServer
    alias Stack 

    def startLink() do
        GenServer.start_link(__MODULE__, [])
    end

    @impl true
    def init(initialState) do
        {:ok, initialState}
    end

    def sendMessage(processId) do
        response = Process.send(processId, :info, [:noconnect])
        IO.inspect(response, label: "222222222222222")
    end

end