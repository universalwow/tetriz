defmodule Tetriz.Boundary.Rules do
  alias Tetriz.Core.{Shape, Board}

  @doc """
  当前形状是否越出边界
  """
  def shape_outside_board?(board, shape, {x_coordinate, y_coordinate}) do
    Shape.with_offset_counted(shape, x_coordinate, y_coordinate)
    |> Enum.reduce_while(false, fn {x, _y}, _acc ->
      if x > 0 and x <= board.width, do: {:cont, false}, else: {:halt, true}
    end)
  end

  @doc """
  检查当前位移是否有效
  有效则返回 无效返回:outside
  """
  def validate_shape_position(board, shape, coordinates) do
    if shape_outside_board?(board, shape, coordinates) do
      {:error, :outside}
    else
      {:ok, coordinates}
    end
  end

  @doc """
  当前形状所在位置
  """
  def detect_colission(board, shape, coordinates) do
    if shape_collides_with_board_tiles?(board, shape, coordinates) do
      {:error, :tile_present}
    else
      {:ok, coordinates}
    end
  end

  @doc """
  当前形状没有没有到达底部
  """
  def not_touches_ground(board, shape, coordinates) do
    if touches_footer?(board, shape, coordinates) do
      {:error, :touches_ground}
    else
      {:ok, board}
    end
  end

  ### API
  # If there is a tile below, then gravity stops. place the tile there.
  # If tile is present below where y axis is less then shape height,
  # then it means there is no place left for new shap and game is over.
  def gravity_pull?(board, shape, {_offset_x, offset_y} = coordinates) do
    if shape_collides_with_board_tiles?(board, shape, coordinates) do
      if offset_y <= shape.length do
        IO.inspect {"game over ", offset_y, shape.length}
        {:error, :game_over}
      else
        {:error, :tile_below}
      end
    else
      {:ok, board}
    end
  end

  @doc """
  到底部之后
  找出没有空缺的行
  进行消除
  """
  def lanes_matured_with_shape_at(board, shape, {_offset_x, offset_y}) do
    # refactor, indexor not needed

    length_lane = fn lane_no ->
      board.lanes
      |> Map.keys()
      |> Enum.filter(fn {_x, y} ->
        y == lane_no
      end)
      |> Enum.count()
    end

    shape.coordinates
    |> Enum.map(fn {_x, y} -> y + offset_y end)
    |> Enum.uniq()
    |> Enum.filter(fn lane -> length_lane.(lane) == board.width end)
  end

  defp shape_collides_with_board_tiles?(board, shape, {offset_x, offset_y}) do
    shape.coordinates
    |> Enum.reduce_while(false, fn {x, y}, _acc ->
      if Board.check_tile_slot_empty?(board, {x + offset_x, y + offset_y}),
        do: {:cont, false},
        else: {:halt, true}
    end)
  end

  @doc """
  当前形状是否到底部
  """
  def touches_footer?(board, shape, {x_coordinate, y_coordinate}) do
    Shape.with_offset_counted(shape, x_coordinate, y_coordinate)
    |> Enum.reduce_while(false, fn {_x, y}, _acc ->
      if y > board.height, do: {:halt, true}, else: {:cont, false}
    end)
  end
end
