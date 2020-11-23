defmodule StackSupervisor do
    use Supervisor

    def startLink do
        Supervisor.start_link(__MODULE__, [])
    end

    @impl true
    def init([]) do
        children = [
            worker(Stack, [])
        ]

        supervise(children, strategy: :one_for_one)
    end
end