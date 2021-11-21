defmodule Tetriz.Core.Shape do
  require Math

  defstruct [
    :coordinates,
    :color,
    :rotate_center,
    :length
  ]

  # 旋转
  def rotate(
        %__MODULE__{
          coordinates: coordinates,
          rotate_center: rotate_center
        } = shape
      ) do
    new_coords =
      coordinates
      |> rotate(rotate_center)

    %__MODULE__{shape | coordinates: MapSet.new(new_coords)}
  end

  def rotate(list, {center_x, center_y}) do
    angle = Math.pi() / 2

    list
    |> Enum.map(fn {x, y} ->
      {
        ((x - center_x) * Math.cos(angle) +
        (y - center_y) * Math.sin(angle) + center_x)
        |> round,
        ((y - center_y) * Math.cos(angle) -
        (x - center_x) * Math.sin(angle) + center_y) |> round
      }
    end)
  end

  @doc """
  Generates a random Shape every time.
  You might want different orientation so you can rotate it as you want.
  """
  def new_random do
    [:l_shape, :l_right_shape,:s_shape, :s_right_shape, :t_shape, :box_shape, :line_shape, :l_boom]
    |> Enum.random()
    |> new
  end

  @doc """
  coordinate {x,y}
  x, y. from 0,0
  l * *
  l * *
  l l *
  L - shape
  """
  def new(:l_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 0}, {0, 1}, {0, 2}, {1, 2}]),
      rotate_center: {1, 1},
      color: :red,
      length: 2
    }
  end


  # coordinate {x,y}
  # x, y. from 0,0
  # * l *
  # * l *
  # l l *
  # L - shape
  def new(:l_right_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 3}, {1, 3}, {1, 2}, {1, 1}]),
      rotate_center: {1, 1},
      color: :pink,
      length: 2
    }
  end

  # coordinate {x,y}
  # x, y. from 0,0
  # * l *
  # * l *
  # l l l
  # L - shape
  def new(:l_boom) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 3}, {1, 3}, {1, 2}, {1, 1}, {2, 3}]),
      rotate_center: {1, 1},
      color: :orchid,
      length: 2
    }
  end

  # coordinate {x,y}
  # x, y. from 0,0
  # * l *
  # l l *
  # * * *
  # L - shape
  def new(:l_small) do
    %__MODULE__{
      coordinates: MapSet.new([{1, 0}, {1, 1}, {0, 1}]),
      rotate_center: {1, 1},
      color: :linen,
      length: 2
    }
  end


  # coordinate {x,y}
  # x, y. from 0,0
  # l * * *
  # l * * *
  # l * * *
  # l * * *
  # L - shape


  def new(:line_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}]),
      rotate_center: {0, 1},
      color: :lime,
      length: 4
    }
  end

  # {x, y}
  # b b *
  # b b *
  # S - shape
  def new(:box_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 0}, {1, 0}, {0, 1}, {1, 1}]),
      rotate_center: {0.5, 0.5},
      color: :yellow,
      length: 2
    }
  end

  # {x, y}
  # s * *
  # s s *
  # * s *
  # S - shape
  def new(:s_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{0, 0}, {0, 1}, {1, 1}, {1, 2}]),
      rotate_center: {0, 1},
      color: :blue,
      length: 2
    }
  end


  # {x, y}
  # * s *
  # s s *
  # s * *
  # S - shape
  def new(:s_right_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{1, 0}, {0, 1}, {1, 1}, {0, 2}]),
      rotate_center: {0, 1},
      color: :green,
      length: 2
    }
  end

  # coordinate {x,y}
  # x, y. from 0,0
  # * t *
  # t t t
  # * * *
  # t - shape
  def new(:t_shape) do
    %__MODULE__{
      coordinates: MapSet.new([{1, 0}, {0, 1}, {1, 1}, {2, 1}]),
      rotate_center: {1, 1},
      color: :orange,
      length: 2
    }
  end

  def with_offset_counted(
        %__MODULE__{coordinates: coordinates} = _shape,
        input_offset_x,
        input_offset_y
      ) do
    Enum.map(coordinates, fn {x, y} -> {x + input_offset_x, y + input_offset_y} end)
  end
end
