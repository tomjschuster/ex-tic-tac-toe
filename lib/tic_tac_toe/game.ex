defmodule TicTacToe.Game do
  alias TicTacToe.Board

  defstruct __state__: {:in_progress, :x}, __board__: Board.new()
end
