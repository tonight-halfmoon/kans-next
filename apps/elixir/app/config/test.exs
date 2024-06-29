import Config

config :testcontainers, enabled: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kans, Kans.Repo,
  hostname: "postgres-ci-testing",
  username: "ci_test",
  password: "ci_test",
  database: "kans_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 4

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kans, KansWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TopGDo1NpemjftibeCjJYdo6vD+fmiwHpiXEkosgqk4a4DxFgGQZwAV1MqtxHuOj",
  server: false

# In test we don't send emails.
config :kans, Kans.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
