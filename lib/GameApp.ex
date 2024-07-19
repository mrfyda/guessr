defmodule GameApp do
  use Application

  def start(_type, _args) do
    if Mix.env() != :test do
      children = [
        {GameLoop, []}
      ]

      opts = [strategy: :one_for_one, name: Supervisor]
      Supervisor.start_link(children, opts)
    else
      {:ok, self()}
    end
  end
end
