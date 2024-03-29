defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid = Enum.filter grid, fn({code, _index} = square) -> 
      rem(code,2) == 0
    end

    %Identicon.Image{image | grid: filtered_grid}
  end

  def mirror_row([a,b,c] = row) do
    # [145,46,200]
    # [145,46,200,46,145]
    [a,b,c,b,a]
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |>Enum.chunk(3)
      |>Enum.map(&mirror_row/1)
      |>List.flatten
      |>Enum.with_index

    %Identicon.Image{image| grid: grid}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end
end
