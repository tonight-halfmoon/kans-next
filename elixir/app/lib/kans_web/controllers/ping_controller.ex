defmodule KansWeb.PingController do
  use KansWeb, :controller

  def ping(conn, _params) do
    text(conn, "pong")
  end
end
