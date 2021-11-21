defmodule HelloPhxWeb.WrongLive do
  use HelloPhxWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect "mount --------------------"
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number."
      )
    }
  end

  def render(assigns) do
    IO.inspect "render --------------------"

    ~L"""
      <h1>Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
        <% end %>
    </h2>
    """
  end
end
