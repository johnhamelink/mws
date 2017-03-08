use Mix.Config

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_url_params: true
]

import_config "test.secret.exs"
