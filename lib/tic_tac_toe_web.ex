defmodule TicTacToeWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: TicTacToeWeb

      import Plug.Conn
      alias TicTacToeWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/tic_tac_toe_web/templates",
        namespace: TicTacToeWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias TicTacToeWeb.Router.Helpers, as: Routes

      import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
