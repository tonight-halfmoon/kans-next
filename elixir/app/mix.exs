defmodule Kans.MixProject do
  use Mix.Project

  @version String.trim(File.read!("./VERSION"))

  def project do
    [
      app: :kans,
      version: @version,
      elixir: "~> 1.16.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [
        summary: [
          threshold: 27
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kans.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:finch, "~> 0.13"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.20"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.7"},
      {:phoenix, "~> 1.7.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.2"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.5"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:testcontainers, "~> 1.8.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup_testing: ["clean", "deps.get", "deps.compile", "compile"],
      setup: ["deps.get", "deps.compile", "compile", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind kans", "esbuild kans"],
      "assets.deploy": [
        "tailwind kans --minify",
        "esbuild kans --minify",
        "phx.digest"
      ],
      testing: [
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test --cover --color --seed 73443"
      ],
      ci_testing: [
        "ecto.create",
        "ecto.migrate",
        "test --cover --color --seed 73443"
      ]
    ]
  end

  def cli do
    [preferred_envs: [ci_testing: :test, setup_testing: :test]]
  end
end
