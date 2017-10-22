# MWS

MWS aims to be a fully-featured and *responsible* Amazon MWS client for Elixir.

## Useful tidbits:

 - [MWS Documentation](https://developer.amazonservices.co.uk/gp/mws/docs.html)
 - [MWS Scratchpad](https://mws.amazonservices.com/scratchpad/index.html)
 
## TODOS:

You can see the [TODO list here](TODOS.md).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mws` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mws, "~> 0.1.0"}]
end
```

## Configuration

```elixir
config :mws,
  seller_id: "xxxx",
  marketplace_id: "xxxx",
  access_key_id: "xxxx",
  secret_key: "xxxx",
  mws_auth_token: "xxxx"
```

## Example Usage

```elixir
config = %Mws.Config{
  endpoint:         Mws.Config.endpoint(:europe),
  seller_id:        Application.get_env(:mws, :seller_id),
  marketplace_id:   Application.get_env(:mws, :marketplace_id),
  access_key_id:    Application.get_env(:mws, :access_key_id),
  secret_key:       Application.get_env(:mws, :secret_key),
  mws_auth_token:   Application.get_env(:mws, :mws_auth_token)
}

Note, `endpoint` (from above) can be one of `:europe`, `:north_america`, `:india`, `:china`, `:japan`.

{:ok, pid} = Mws.Client.start_link(config)

response = Mws.Product.get_matching_product(pid, "B017R5CP1C")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mws](https://hexdocs.pm/mws).

