# Operations Manual

## Run Unit Tests in a Docker container (App Elixir)

```shell
make --directory=./apps/elixir/app network_create
make --directory=./apps/elixir/app postgres_ci_testing
make --directory=./apps/elixir/app image_build_ci_testing
make --directory=./apps/elixir/app container_run_ci_testing
```

## Run GitHub Actions CI pipeline locally

```shell
make act
```
