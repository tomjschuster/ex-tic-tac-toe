defmodule TicTacToe do
  defmodule Board do
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

  defmodule Game do
    defstruct state: {:in_progress, :x}, board: Board.new()
  end

  def new_game, do: %Game{}

  def started?(%Game{board: board}) do
    not Board.empty?(board)
  end

  def mark(game, player, position) do
    with {:ok, game} <- do_mark(game, player, position),
         do: {:ok, maybe_end_game(game)}
  end

  defp do_mark(%Game{state: :tie}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%Game{state: {:winner, _}}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%Game{}, player, {_x, _y})
       when player not in [:x, :y],
       do: {:error, :invalid_player}

  defp do_mark(%Game{state: {:in_progress, next_player}}, player, {_x, _y})
       when next_player != player,
       do: {:error, :out_of_turn}

  defp do_mark(%Game{}, _player, {x, y}) when x < 1 or x > 3 or y < 1 or y > 3,
    do: {:error, :out_of_bounds}

  defp do_mark(%Game{} = game, player, {x, y}) do
    case game.board do
      %{^x => %{^y => nil}} ->
        {:ok,
         %Game{
           game
           | state: {:in_progress, next_player(player)},
             board: update_in(game.board, [x, y], fn _ -> player end)
         }}

      %{^x => %{^y => _}} ->
        {:error, :already_marked}
    end
  end

  defp next_player(:x), do: :y
  defp next_player(:y), do: :x

  defp maybe_end_game(%Game{board: board} = game) do
    winner = check_rows(board) || check_columns(board) || check_diagonals(board)

    cond do
      winner -> %Game{game | state: {:winner, winner}}
      Board.full?(board) -> %Game{game | state: :tie}
      true -> game
    end
  end

  defp check_rows(%{1 => %{1 => a}, 2 => %{1 => a}, 3 => %{1 => a}}) when not is_nil(a), do: a
  defp check_rows(%{1 => %{2 => a}, 2 => %{2 => a}, 3 => %{2 => a}}) when not is_nil(a), do: a
  defp check_rows(%{1 => %{3 => a}, 2 => %{3 => a}, 3 => %{3 => a}}) when not is_nil(a), do: a
  defp check_rows(_board), do: nil

  defp check_columns(%{1 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(%{2 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(%{3 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(_board), do: nil

  defp check_diagonals(%{1 => %{1 => a}, 2 => %{2 => a}, 3 => %{3 => a}}) when not is_nil(a),
    do: a

  defp check_diagonals(%{1 => %{3 => a}, 2 => %{2 => a}, 3 => %{1 => a}}) when not is_nil(a),
    do: a

  defp check_diagonals(_board), do: nil
end
