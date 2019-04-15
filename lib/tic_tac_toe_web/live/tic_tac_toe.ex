defmodule TicTacToeWeb.TicTacToeLive do
  use Phoenix.LiveView

  def render(%{game: game}) do
    case TicTacToe.state(game) do
      :winner ->
        render_winner(game)

      :tie ->
        render_tie()

      :in_progress ->
        render_board(game)
    end
  end

  def render_winner(game, assigns \\ %{}) do
    ~L"""
      <p><%= TicTacToe.winner(game) %> wins!</p>
      <button phx-click="replay">Replay</button>
    """
  end

  def render_tie(assigns \\ %{}) do
    ~L"""
      <p>It's a tie!</p><button phx-click="replay">Replay</button>
    """
  end

  def render_board(game, assigns \\ %{}) do
    ~L"""
    <style>td { width: 50px; height: 50px; border: 1px solid black; }</style>
    <table>
      <%= for row <- TicTacToe.board(game) do %>
        <%= render_row(row) %>
      <% end %>
    <table>
    """
  end

  def render_row(row, assigns \\ %{}) do
    ~L"""
      <tr>
        <%= for square <- row do %>
        <%= render_square(square) %>
        <% end %>
      </tr>
    """
  end

  def render_square(square, assigns \\ %{})

  def render_square(%{x: x, y: y, mark: nil}, assigns) do
    ~L"""
    <td phx-click="mark" phx-value="[<%= x %>, <%= y %>]"></td>
    """
  end

  def render_square(%{mark: mark}, assigns) do
    ~L"""
      <td><%= mark %></td>
    """
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
