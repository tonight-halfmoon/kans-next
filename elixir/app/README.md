# Kans

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please
[check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- [Official website](https://www.phoenixframework.org/)
- [Guides](https://hexdocs.pm/phoenix/overview.html)
- [Docs](https://hexdocs.pm/phoenix)
- [Forum](https://elixirforum.com/c/phoenix-forum)
- [Source](https://github.com/phoenixframework/phoenix)

## Docker image optimisation in Stage 1

Utilise mount instead of the following COPY instruction

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

## Required contents of a healthy image

```shell
<<-EOT
  set -e
  ls /app/lib /app/assets /app/priv /app/bin /app/entrypoint.alpine.sh
EOT
```

## Docker image optimisation - Multi-stage build

Utilised two Phases as recommended by the output of `mix phx.gen.release --docker`
to achieve up to this Git commit `61.09MB`

## To-Do (Near Future)

### Docker Image (Alpine)

Utilise the Docker image
`hexpm/elixir:1.16.3-erlang-26.2.5-alpine-3.20.0`, for the first stage
of the image
