defmodule GameApp do
  use Application

  def start(_type, _args) do
    children = [
      {GameLoop, []}
    ]

    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end
end
