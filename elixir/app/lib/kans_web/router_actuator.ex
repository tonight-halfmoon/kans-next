defmodule KansWeb.RouterActuator do
  use Plug.Router

  plug :match

  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug :fetch_query_params
  plug :dispatch

  get "/healthz" do
    message = interpret_conn_params(conn.params)
    send_resp(conn, 200, message)
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end

  defp interpret_conn_params(%{"full" => "true"}), do: "I am alive!"
  defp interpret_conn_params(_), do: "ok"
end
