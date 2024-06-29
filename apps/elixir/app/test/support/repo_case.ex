defmodule Kans.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Kans.Repo

      import Ecto
      import Ecto.Query
      import Kans.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kans.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kans.Repo, {:shared, self()})
    end

    :ok
  end
end
