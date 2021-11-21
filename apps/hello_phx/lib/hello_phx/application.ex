defmodule HelloPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HelloPhx.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: HelloPhx.PubSub}
      # Start a worker by calling: HelloPhx.Worker.start_link(arg)
      # {HelloPhx.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: HelloPhx.Supervisor)
  end
end
