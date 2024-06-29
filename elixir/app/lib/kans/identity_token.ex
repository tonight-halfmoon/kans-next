defmodule Kans.IdentityToken do
  defstruct conn: nil,
            token_string: nil,
            token_payload: nil,
            user: nil,
            user_metadata: nil,
            halted: false,
            error: nil
end
