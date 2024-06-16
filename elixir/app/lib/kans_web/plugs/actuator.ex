defmodule KansWeb.Plugs.Actuator do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health", query_params: "full"} = conn) do
    conn
    |> put_resp_content_type("text/plain; charset=utf-8")
    |> send_resp(200, "ok")
    |> halt()
  end

  def call(%Plug.Conn{request_path: "/healthz"} = conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "up"}))
    |> halt()
  end

  def call(conn, _opts), do: conn
end
