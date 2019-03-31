defmodule TicTacToe do
  alias TicTacToe.{Board, Game}

  # Create/Modify
  def new_game, do: %Game{}

  def mark(game, player, position) do
    with {:ok, game} <- do_mark(game, player, position),
         do: {:ok, maybe_end_game(game)}
  end

  # Query
  def board(%Game{__board__: board_}) do
    for x <- 1..3 do
      for y <- 1..3 do
        %{x: x, y: y, mark: board_[x][y]}
      end
    end
  end

  def state(%Game{__state__: {:in_progress, _}}), do: :in_progress
  def state(%Game{__state__: {:winner, _}}), do: :winner
  def state(%Game{__state__: :tie}), do: :tie

  def started?(%Game{__board__: board_}), do: not Board.empty?(board_)

  def in_progress?(%Game{__state__: {:in_progress, _}}), do: true
  def in_progress?(%Game{}), do: false

  def finished?(%Game{__state__: {:winner, _}}), do: true
  def finished?(%Game{__state__: :tie}), do: true
  def finished?(%Game{}), do: false

  def current_player(%Game{__state__: {:in_progress, player}}), do: player
  def current_player(%Game{}), do: nil

  def winner(%Game{__state__: {:winner, winner}}), do: winner
  def winner(%Game{}), do: nil

  # Helpers
  defp do_mark(%Game{__state__: :tie}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%Game{__state__: {:winner, _}}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%Game{}, player, {_x, _y})
       when player not in [:x, :o],
       do: {:error, :invalid_player}

  defp do_mark(%Game{__state__: {:in_progress, current}}, player, {_x, _y})
       when current != player,
       do: {:error, :out_of_turn}

  defp do_mark(%Game{}, _player, {x, y}) when x < 1 or x > 3 or y < 1 or y > 3,
    do: {:error, :out_of_bounds}

  defp do_mark(%Game{__board__: board_} = game, player, {x, y}) do
    case board_ do
      %{^x => %{^y => nil}} ->
        {:ok,
         %Game{
           game
           | __state__: {:in_progress, toggle_player(player)},
             __board__: update_in(board_, [x, y], fn _ -> player end)
         }}

      %{^x => %{^y => _}} ->
        {:error, :already_marked}
    end
  end

  defp toggle_player(:x), do: :o
  defp toggle_player(:o), do: :x

  defp maybe_end_game(%Game{__board__: board_} = game) do
    winner = check_rows(board_) || check_columns(board_) || check_diagonals(board_)

    cond do
      winner -> %Game{game | __state__: {:winner, winner}}
      Board.full?(board_) -> %Game{game | __state__: :tie}
      true -> game
    end
  end

  defp check_rows(%{1 => %{1 => a}, 2 => %{1 => a}, 3 => %{1 => a}}) when not is_nil(a), do: a
  defp check_rows(%{1 => %{2 => a}, 2 => %{2 => a}, 3 => %{2 => a}}) when not is_nil(a), do: a
  defp check_rows(%{1 => %{3 => a}, 2 => %{3 => a}, 3 => %{3 => a}}) when not is_nil(a), do: a
  defp check_rows(_board_), do: nil

  defp check_columns(%{1 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(%{2 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(%{3 => %{1 => a, 2 => a, 3 => a}}) when not is_nil(a), do: a
  defp check_columns(_board_), do: nil

  defp check_diagonals(%{1 => %{1 => a}, 2 => %{2 => a}, 3 => %{3 => a}}) when not is_nil(a),
    do: a

  defp check_diagonals(%{1 => %{3 => a}, 2 => %{2 => a}, 3 => %{1 => a}}) when not is_nil(a),
    do: a

  defp check_diagonals(_board_), do: nil
end
