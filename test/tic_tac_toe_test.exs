defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  test "creates a new game where x goes first" do
    game = TicTacToe.new_game()
    assert TicTacToe.state(game) == :in_progress
    assert TicTacToe.current_player(game) == :x
  end

  test "fails when player goes out of turn" do
    game = TicTacToe.new_game()
    assert TicTacToe.mark(game, :o, {1, 1}) == {:error, :out_of_turn}

    {:ok, game} = TicTacToe.mark(game, :x, {1, 1})
    assert TicTacToe.mark(game, :x, {1, 1}) == {:error, :out_of_turn}
  end

  test "fails when invalid player goes" do
    game = TicTacToe.new_game()
    assert TicTacToe.mark(game, :z, {1, 1}) == {:error, :invalid_player}
  end

  test "fails when position is out of bounds" do
    game = TicTacToe.new_game()
    assert TicTacToe.mark(game, :x, {4, 1}) == {:error, :out_of_bounds}
    assert TicTacToe.mark(game, :x, {0, 1}) == {:error, :out_of_bounds}
  end

  test "fails when position already marked" do
    {:ok, game} =
      TicTacToe.new_game()
      |> TicTacToe.mark(:x, {1, 1})

    assert TicTacToe.mark(game, :o, {1, 1}) == {:error, :already_marked}
  end

  test "fails when game is over" do
    {:ok, game1} =
      with game1 <- TicTacToe.new_game(),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {1, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {1, 2}),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {2, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {2, 2}),
           do: TicTacToe.mark(game1, :x, {3, 1})

    assert TicTacToe.mark(game1, :o, {3, 2}) == {:error, :game_already_over}

    {:ok, game2} =
      with game2 <- TicTacToe.new_game(),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {1, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {2, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {1, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {1, 3}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {2, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {3, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {3, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {3, 3}),
           do: TicTacToe.mark(game2, :x, {2, 3})

    assert TicTacToe.mark(game2, :o, {3, 3}) == {:error, :game_already_over}
  end

  test "wins with rows" do
    {:ok, game1} =
      with game1 <- TicTacToe.new_game(),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {1, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {1, 2}),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {2, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {2, 2}),
           do: TicTacToe.mark(game1, :x, {3, 1})

    assert TicTacToe.state(game1) == :winner
    assert TicTacToe.winner(game1) == :x

    {:ok, game2} =
      with game2 <- TicTacToe.new_game(),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {1, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {1, 3}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {2, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {2, 3}),
           do: TicTacToe.mark(game2, :x, {3, 2})

    assert TicTacToe.state(game2) == :winner
    assert TicTacToe.winner(game2) == :x

    {:ok, game3} =
      with game3 <- TicTacToe.new_game(),
           {:ok, game3} <- TicTacToe.mark(game3, :x, {1, 3}),
           {:ok, game3} <- TicTacToe.mark(game3, :o, {1, 2}),
           {:ok, game3} <- TicTacToe.mark(game3, :x, {2, 3}),
           {:ok, game3} <- TicTacToe.mark(game3, :o, {2, 2}),
           do: TicTacToe.mark(game3, :x, {3, 3})

    assert TicTacToe.state(game3) == :winner
    assert TicTacToe.winner(game3) == :x
  end

  test "wins with columns" do
    {:ok, game1} =
      with game1 <- TicTacToe.new_game(),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {1, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {2, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {1, 2}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {2, 2}),
           do: TicTacToe.mark(game1, :x, {1, 3})

    assert TicTacToe.state(game1) == :winner
    assert TicTacToe.winner(game1) == :x

    {:ok, game2} =
      with game2 <- TicTacToe.new_game(),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {2, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {1, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {2, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {1, 2}),
           do: TicTacToe.mark(game2, :x, {2, 3})

    assert TicTacToe.state(game2) == :winner
    assert TicTacToe.winner(game2) == :x

    {:ok, game3} =
      with game3 <- TicTacToe.new_game(),
           {:ok, game3} <- TicTacToe.mark(game3, :x, {3, 1}),
           {:ok, game3} <- TicTacToe.mark(game3, :o, {1, 1}),
           {:ok, game3} <- TicTacToe.mark(game3, :x, {3, 2}),
           {:ok, game3} <- TicTacToe.mark(game3, :o, {1, 2}),
           do: TicTacToe.mark(game3, :x, {3, 3})

    assert TicTacToe.state(game3) == :winner
    assert TicTacToe.winner(game3) == :x
  end

  test "wins with diagonals" do
    {:ok, game1} =
      with game1 <- TicTacToe.new_game(),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {1, 1}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {1, 3}),
           {:ok, game1} <- TicTacToe.mark(game1, :x, {2, 2}),
           {:ok, game1} <- TicTacToe.mark(game1, :o, {3, 1}),
           do: TicTacToe.mark(game1, :x, {3, 3})

    assert TicTacToe.state(game1) == :winner
    assert TicTacToe.winner(game1) == :x

    {:ok, game2} =
      with game2 <- TicTacToe.new_game(),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {1, 3}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {1, 1}),
           {:ok, game2} <- TicTacToe.mark(game2, :x, {2, 2}),
           {:ok, game2} <- TicTacToe.mark(game2, :o, {3, 3}),
           do: TicTacToe.mark(game2, :x, {3, 1})

    assert TicTacToe.state(game2) == :winner
    assert TicTacToe.winner(game2) == :x
  end

  test "y can win" do
    {:ok, game} =
      with game <- TicTacToe.new_game(),
           {:ok, game} <- TicTacToe.mark(game, :x, {1, 1}),
           {:ok, game} <- TicTacToe.mark(game, :o, {2, 1}),
           {:ok, game} <- TicTacToe.mark(game, :x, {1, 2}),
           {:ok, game} <- TicTacToe.mark(game, :o, {2, 2}),
           {:ok, game} <- TicTacToe.mark(game, :x, {3, 1}),
           do: TicTacToe.mark(game, :o, {2, 3})

    assert TicTacToe.state(game) == :winner
    assert TicTacToe.winner(game) == :o
  end

  test "tie when whole board filled without winner" do
    {:ok, game} =
      with game <- TicTacToe.new_game(),
           {:ok, game} <- TicTacToe.mark(game, :x, {1, 1}),
           {:ok, game} <- TicTacToe.mark(game, :o, {2, 1}),
           {:ok, game} <- TicTacToe.mark(game, :x, {1, 2}),
           {:ok, game} <- TicTacToe.mark(game, :o, {1, 3}),
           {:ok, game} <- TicTacToe.mark(game, :x, {2, 2}),
           {:ok, game} <- TicTacToe.mark(game, :o, {3, 2}),
           {:ok, game} <- TicTacToe.mark(game, :x, {3, 1}),
           {:ok, game} <- TicTacToe.mark(game, :o, {3, 3}),
           do: TicTacToe.mark(game, :x, {2, 3})

    assert TicTacToe.state(game) == :tie
  end
end
