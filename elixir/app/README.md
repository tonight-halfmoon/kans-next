# Kans

To start your Phoenix server:

  - Run `mix setup` to install and setup dependencies
  - Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please
[check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Docker image optimisation

```Dockerfile
# COPY priv priv

# COPY assets assets

# COPY rel rel

# COPY mix.exs .
# COPY VERSION .
# # COPY lib lib
# COPY config/config.exs config/
# COPY config/${MIX_ENV}.exs ./config/
# COPY config/runtime.exs ./config/

# COPY --from=build --chown=10000:10000 /app /app

# WORKDIR /app
```

## How this app is generated

<!--@include:./operations-manual/installation.md-->
