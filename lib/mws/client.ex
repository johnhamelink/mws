defmodule Mws.Client do
  use GenServer
  alias Mws.{Parser, Auth}
  require Logger

  @doc """
  Start a client process which contains a config
  """

  def start_link(config = %Mws.Config{}) do
    GenServer.start_link(__MODULE__, [config: config])
  end

  def request(pid, verb, uri = %URI{}, parser),
  do: request(pid, verb, uri, "", parser)

  def request(pid, verb, uri = %URI{}, body, parser),
  do: GenServer.call(pid, {:request, verb, uri, body, parser})

  def handle_call({:request, verb, uri, body, parser}, _from, state) do
    config = state[:config]
    endpoint = config.endpoint

    # 1. Add endpoint info
    # 2. Retrieve query & add the signature to it
    # 3. Make the request
    # 4. Deserialize the response
    uri = %{uri | host: endpoint.host, scheme: endpoint.scheme, port: 443}
    uri = %{uri | query: calculate_content_signature(uri.query, body)}
    uri = %{uri | query: Auth.sign(config, {verb, uri})}

    req =
      HTTPoison.request(verb, uri, body, default_headers())
      |> Parser.handle_response(parser)

    {:reply, req, state}
  end

  defp default_headers() do
    [
      {"User-Agent", user_agent_string()},
      {"Content-Type", "text/xml"}
    ]
  end

  defp user_agent_string() do
    {:ok, vsn} = :application.get_key(:mws, :vsn)
    vsn = List.to_string(vsn)
    "MWS/#{vsn} (Language=Elixir)"
  end

  defp calculate_content_signature(query, body) do
    hash = Base.encode64(:crypto.hash(:md5, body), case: :lower)
    Map.put(query, "ContentMD5Value", hash)
  end

end
