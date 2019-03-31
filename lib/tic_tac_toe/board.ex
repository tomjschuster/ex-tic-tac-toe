defmodule TicTacToe.Board do
  def new do
    Enum.into(1..3, %{}, fn x ->
      row = Enum.into(1..3, %{}, fn y -> {y, nil} end)
      {x, row}
    end)
  end

  def empty?(board) do
    Enum.all?(board, fn {_, row} ->
      Enum.all?(row, fn {_, v} -> is_nil(v) end)
    end)
  end

  def full?(board) do
    Enum.all?(board, fn {_, row} ->
      Enum.all?(row, fn {_, v} -> not is_nil(v) end)
    end)
  end
end
