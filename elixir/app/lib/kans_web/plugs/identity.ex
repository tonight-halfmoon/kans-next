defmodule KansWeb.Plugs.Identity do
  @moduledoc """
  Plug for authenticating an incoming request.
  A `Bearer` token or simply a JWT token is expected
  in the `Authorization` header of the request.
  """
  import Plug.Conn, only: [assign: 3, get_req_header: 2]

  alias Kans.Auth
  alias Kans.IdentityToken
  alias KansWeb.FallbackController

  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    %IdentityToken{conn: conn}
    |> get_token()
    |> validate()
    |> new_user()
    |> handle()
  end

  defp get_token(%IdentityToken{conn: conn} = token) do
    case get_req_header(conn, "authorization") do
      [token_string | _] ->
        %IdentityToken{token | token_string: token_string}

      [] ->
        Logger.error("Expected a token in the `authorization` header!")
        %IdentityToken{token | halted: true, error: {:error, :no_token}}
    end
  end

  defp validate(%IdentityToken{halted: true} = token), do: token

  defp validate(%IdentityToken{token_string: token_string} = token) do
    case Auth.validate_x(token_string) do
      {:ok, payload} ->
        %IdentityToken{token | token_payload: payload}

      {:error, error} ->
        %IdentityToken{token | halted: true, error: {:error, error}}
    end
  end

  defp new_user(%IdentityToken{halted: true} = token), do: token

  defp new_user(%IdentityToken{user_metadata: _} = token),
    do: %IdentityToken{token | user: :fake_user}

  defp handle(%IdentityToken{conn: conn, halted: true, error: error}) do
    no_user = %{user_id: "_"}
    error = if {:error, no_user} == error, do: {:error, :unauthorized}, else: error
    FallbackController.call(conn, error)
  end

  defp handle(%IdentityToken{conn: conn, user: user}), do: assign(conn, :user, user)
end
