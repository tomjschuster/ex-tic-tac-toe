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

  defstruct __state__: {:in_progress, :x}, __board__: Board.new()

  # Create/Modify
  def new_game, do: %__MODULE__{}

  def mark(game, player, position) do
    with {:ok, game} <- do_mark(game, player, position),
         do: {:ok, maybe_end_game(game)}
  end

  # Query
  def board(%__MODULE__{__board__: board_}) do
    for x <- 1..3 do
      for y <- 1..3 do
        %{x: x, y: y, mark: board_[x][y]}
      end
    end
  end

  def state(%__MODULE__{__state__: {:in_progress, _}}), do: :in_progress
  def state(%__MODULE__{__state__: {:winner, _}}), do: :winner
  def state(%__MODULE__{__state__: :tie}), do: :tie

  def started?(%__MODULE__{__board__: board_}), do: not Board.empty?(board_)

  def in_progress?(%__MODULE__{__state__: {:in_progress, _}}), do: true
  def in_progress?(%__MODULE__{}), do: false

  def finished?(%__MODULE__{__state__: {:winner, _}}), do: true
  def finished?(%__MODULE__{__state__: :tie}), do: true
  def finished?(%__MODULE__{}), do: false

  def current_player(%__MODULE__{__state__: {:in_progress, player}}), do: player
  def current_player(%__MODULE__{}), do: nil

  def winner(%__MODULE__{__state__: {:winner, winner}}), do: winner
  def winner(%__MODULE__{}), do: nil

  # Helpers
  defp do_mark(%__MODULE__{__state__: :tie}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%__MODULE__{__state__: {:winner, _}}, _player, {_x, _y}),
    do: {:error, :game_already_over}

  defp do_mark(%__MODULE__{}, player, {_x, _y})
       when player not in [:x, :o],
       do: {:error, :invalid_player}

  defp do_mark(%__MODULE__{__state__: {:in_progress, current}}, player, {_x, _y})
       when current != player,
       do: {:error, :out_of_turn}

  defp do_mark(%__MODULE__{}, _player, {x, y}) when x < 1 or x > 3 or y < 1 or y > 3,
    do: {:error, :out_of_bounds}

  defp do_mark(%__MODULE__{__board__: board_} = game, player, {x, y}) do
    case board_ do
      %{^x => %{^y => nil}} ->
        {:ok,
         %__MODULE__{
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

  defp maybe_end_game(%__MODULE__{__board__: board_} = game) do
    winner = check_rows(board_) || check_columns(board_) || check_diagonals(board_)

    cond do
      winner -> %__MODULE__{game | __state__: {:winner, winner}}
      Board.full?(board_) -> %__MODULE__{game | __state__: :tie}
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
