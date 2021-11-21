defmodule HelloPhxWeb.Tetriz.Index do
  use Phoenix.LiveView
  alias Tetriz.Core.{Game}
  alias Tetriz.Boundary.{GameLogic}

  def mount(_params, _session, socket) do

    width = Application.get_env(:hello_phx_web, :board_width)
    height = Application.get_env(:hello_phx_web, :board_height)
    offset_x = Application.get_env(:hello_phx_web, :init_offset_x)
    offset_y = Application.get_env(:hello_phx_web, :init_offset_y)
    game = Game.new(%{width: width, height: height, offset_x: offset_x, offset_y: offset_y})
    new_socket = generate_socket_from_game(socket, game)
    Process.send_after(self(), :tick, 500)

    {:ok, new_socket}
  end

  # def handle_info({:state_change, new_state}, socket) do
  #   {:noreply, generate_socket_from_state(socket, new_state)}
  # end

  def handle_event("tetris", "rotate", socket) do
    {:noreply, socket}
  end

  def handle_event("move", %{"key" => key}, socket) when false == socket.assigns.game_over do
    game = generate_game_from_socket(socket)
    # game.game_over == true
    res =
      case key do
        "ArrowRight" -> GameLogic.move(game, :right)
        "ArrowLeft" -> GameLogic.move(game, :left)
        "ArrowUp" -> GameLogic.rotate(game)
        "ArrowDown" -> GameLogic.move(game, :down)
        _ -> nil
      end

    updated_socket = generate_socket_from_game(socket, res)

    {:noreply, updated_socket}
    # {:noreply, socket}
  end


  def handle_info(:tick, socket) do
    game_state = generate_game_from_socket(socket)
    # res = GameLogic.move(game, :gravity)

    state_after_move = GameLogic.move(game_state, :gravity)

    if state_after_move.current_state == :game_over do
      IO.puts("Game Over...")
    else
      Process.send_after(self(), :tick, 500)
    end

    updated_socket = generate_socket_from_game(socket, state_after_move)
    {:noreply, updated_socket}
  end

  defp generate_game_from_socket(socket) do
    game_over = socket.assigns.game_over
    board = socket.assigns.board
    active_shape = socket.assigns.active_shape
    next_shape = socket.assigns.next_shape
    score = socket.assigns.score
    offset_x = socket.assigns.offset_x
    offset_y = socket.assigns.offset_y

    %Game{
      offset_x: offset_x,
      offset_y: offset_y,
      active_shape: active_shape,
      board: board,
      game_over: game_over,
      next_shape: next_shape,
      score: score
    }
  end

  defp generate_socket_from_game(socket, game) do
    assign(socket,
      board: game.board,
      active_shape: game.active_shape,
      next_shape: game.next_shape,
      score: game.score,
      game_over: game.game_over,
      offset_x: game.offset_x,
      offset_y: game.offset_y,
      lanes: game.board.lanes,
      new_game: true,
      speed: 600
    )
  end

  def render(assigns) do

    HelloPhxWeb.TetrizView.render("tetriz-game.html", assigns)
  end
end
