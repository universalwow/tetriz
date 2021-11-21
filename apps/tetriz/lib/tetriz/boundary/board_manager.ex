defmodule Tetriz.Boundary.BoardManager do
  alias Tetriz.Core.{Board, Shape}
  alias Tetriz.Boundary.{Rules}

  @doc """
  向界面添加元素
  """
  def add(
        %Board{} = board,
        %Shape{
          color: shape_color,
          coordinates: coordinates
        } = shape,
        {offset_x, offset_y}
      ) do
    if Rules.shape_outside_board?(board, shape, {offset_x, offset_y}) do
      {:error, :out_of_board}
    else
      tiles = Enum.map(coordinates, fn {x, y} -> {x + offset_x, y + offset_y} end)

      u_board =
        Enum.reduce(tiles, board, fn tile, acc_board ->
          add_tile_to_board(acc_board, tile, shape_color)
        end)

      {:ok, u_board}
    end
  end

  def add_tile_to_board(board, tile, color) do
    u_lanes = Map.put(board.lanes, tile, color)
    %Board{board | lanes: u_lanes}
  end

  @doc """
  从界面删除元素
  并将该行上部元素下移一位
  """
  def remove_lanes_from_board(board, rows) do
    IO.inspect(
      {"remove_lanes_from_board......................", board.lanes,
       for y <- rows, x <- 1..board.width, into: [] do
         {x, y}
       end}
    )

    u_lanes =
      Map.drop(
        board.lanes,
        for y <- rows, x <- 1..board.width, into: [] do
          {x, y}
        end
      )

    # 首先进行排序 y 需要大的靠前， 首先更新
    updated_lanes =
      Enum.reduce(
        rows,
        u_lanes
        |> Map.to_list(),
        fn boundary_y, acc ->
          Enum.map(
            acc,
            fn {{x, y}, color} = lane ->
              if y < boundary_y do
                {{x, y + 1}, color}
              else
                lane
              end
            end
          )
        end
      )
      |> Map.new
    %Board{board | lanes: updated_lanes}
  end
end
