# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :eye_drops,
  tasks: [
    %{
      id: :unit_tests,
      name: "Unit tests",
      run_on_start: true,
      cmd: "mix test --color",
      paths: ["lib/*", "test/*"]
    }
  ]

import_config "#{Mix.env}.exs"
