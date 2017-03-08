defmodule Mws.Client do
  use HTTPoison.Base
  alias Mws.{Parser, Auth}
  require Logger

  def request(config = %Mws.Config{endpoint: endpoint}, {verb, uri = %URI{}}, parser) do
    # 1. Add endpoint info
    # 2. Retrieve query & add the signature to it
    # 3. Make the request
    # 4. Deserialize the response

    uri = %{uri | host: endpoint.host, scheme: endpoint.scheme, port: 443}
    uri = %{uri | query: Auth.sign(config, {verb, uri})}

    call_api(verb, uri, [], parser)
  end

  defp call_api(verb, uri = %URI{}, body, parser) do
    request(verb, uri, body, default_headers())
    |> Parser.handle_response(parser)
  end

  defp default_headers() do
    [
      {"User-Agent", user_agent_string()},
      {"Content-Type", "x-www-form-urlencoded"}
    ]
  end

  defp user_agent_string() do
    {:ok, vsn} = :application.get_key(:mws, :vsn)
    vsn = List.to_string(vsn)
    "MWS/#{vsn} (Language=Elixir)"
  end
end
