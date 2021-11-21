defmodule Tetriz.Core.Board do
    @default_width 40
    @default_height 50
  
    defstruct [
      :tiles,
      :seq_map,
      :width,
      :height,
      :lanes
    ]
  
    def new(input_width \\ @default_width, input_height \\ @default_height) do
      %__MODULE__{
        width: input_width,
        height: input_height,
        lanes: %{}
      }
    end
  
    def check_tile_slot_empty?(board, tile) do
      tile_color = Map.get(board.lanes, tile, :empty)
  
      if tile_color == :empty do
        true
      else
        false
      end
    end
  
  end
  