defmodule Queue do
  use GenServer

  # Client

  def start_link(initial_queue) when is_list(initial_queue) do
    GenServer.start_link(__MODULE__, initial_queue)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (Callbacks)
  @impl true
  def init(queue) do
    {:ok, queue}
  end

  @impl true
  # ASYNC
  def handle_cast({:push, element}, queue) do
    {:noreply, queue ++ [element]}
  end

  @impl true
  # SYNC
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  # SYNC
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end
end
