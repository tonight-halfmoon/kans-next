defmodule KansWeb.EndpointActuator do
  use Phoenix.Endpoint, otp_app: :kans

  plug KansWeb.RouterActuator
end
