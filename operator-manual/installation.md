# Installation & Set up New Project

## New Project

```shell
mix archive.install hex phx_new
mix local.hex
```

```shell
mix phx.new . --module Kans --app kans --adapter cowboy
```

## New Database (Postgresql) [local]

```shell
createuser postgres

pg_ctl \
  --pgdata="${HOME}"/.local/var/postgres --log="${HOME}"/.local/var/postgres-run-"${USER}".logs
  --options="-U postgres" initdb

createdb kans_db --owner=postgres --username=postgres
```

```shell
pg_ctl --pgdata="${HOME}"/.local/var/postgres --log="${HOME}"/.local/var/postgres-run-"${USER}".logs start
```

## Mix ecto Task

```shell
mix ecto.create
```
