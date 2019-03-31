defmodule TicTacToeWeb.GameLive do
  use Phoenix.LiveView

  def render(%{game: game}) do
    case game do
      %TicTacToe.Game{state: {:winner, winner}} ->
        render_winner(winner)

      %TicTacToe.Game{state: :tie} ->
        render_tie()

      %TicTacToe.Game{state: {:in_progress, _}} ->
        render_board(game, TicTacToe.in_progress?(game))
    end
  end

  def render_winner(winner, assigns \\ %{}) do
    ~L(<p><%= winner %> wins!</p><button phx-click="replay">Replay</button>)
  end

  def render_tie(assigns \\ %{}) do
    ~L(<p>It's a tie!</p><button phx-click="replay">Replay</button>)
  end

  def render_board(game, active?, assigns \\ %{}) do
    ~L"""
    <style>
      td {
        width: 50px;
        height: 50px;
        border: 1px solid black;
      }
    </style>
    <table>
      <%= for row <- board_rows(game) do %>
        <%= render_row(row, active?) %>
      <% end %>
    <table>
    """
  end

  def board_rows(%TicTacToe.Game{board: board}) do
    for x <- 1..3 do
      for y <- 1..3 do
        %{x: x, y: y, mark: board[x][y]}
      end
    end
  end

  def render_row(row, active?, assigns \\ %{}) do
    ~L"""
      <tr>
        <%= for square <- row do %>
        <%= render_square(square, active?) %>
        <% end %>
      </tr>
    """
  end

  def render_square(%{x: x, y: y, mark: mark}, active?, assigns \\ %{}) do
    if active? and !mark do
      ~L(<td phx-click="mark" phx-value="[<%= x %>, <%= y %>]"><%= mark %></td>)
    else
      ~L(<td><%= mark %></td>)
    end
  end

  def mount(_session, socket) do
    socket =
      socket
      |> assign(:game, TicTacToe.new_game())
      |> assign(:error, nil)

    {:ok, socket}
  end

  def handle_event("mark", value, %{assigns: %{game: game}} = socket) do
    [x, y] = Jason.decode!(value)
    player = TicTacToe.current_player(game)

    case TicTacToe.mark(game, player, {x, y}) do
      {:ok, game} ->
        updated_socket = socket |> assign(:game, game) |> assign(:error, nil)
        {:noreply, updated_socket}

      {:error, error} ->
        updated_socket = assign(socket, :error, error)
        {:noreply, updated_socket}
    end
  end

  def handle_event("replay", "", socket) do
    socket =
      socket
      |> assign(:game, TicTacToe.new_game())
      |> assign(:error, nil)

    {:noreply, socket}
  end
end
