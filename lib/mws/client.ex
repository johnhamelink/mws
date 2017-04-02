defmodule Mws.Client do
  use GenServer
  alias Mws.{Parser, Auth, Utils}
  require Logger

  @doc """
  Start a client process which contains a config
  """

  def start_link(config = %Mws.Config{}) do
    GenServer.start_link(__MODULE__, [config: config])
  end

  def request(pid, verb, uri = %URI{}),
  do: request(pid, verb, uri, "")

  def request(pid, verb, uri = %URI{}, body),
  do: GenServer.call(pid, {:request, verb, uri, body})

  def handle_call({:request, verb, uri, body}, _from, state) do
    config = state[:config]
    endpoint = config.endpoint

    # 1. Add any endpoint-specific modifications
    # 2. Add endpoint info
    # 3. Retrieve query & add the signature to it
    # 4. Make the request
    # 5. Deserialize the response
    uri = %{uri | query: Auth.prepare_for_signature(config, uri.query)}
    uri = %{uri | query: Utils.prepare_query(uri.query, uri.path)}
    uri = %{uri | host:  endpoint.host, scheme: endpoint.scheme, port: 443}
    uri = %{uri | query: calculate_content_signature(uri.query, body)}
    uri = %{uri | query: Auth.sign(config, {verb, uri})}

    Logger.debug "Calling URL: #{URI.to_string uri}"

    req =
      HTTPoison.request(verb, uri, body, default_headers())
      |> Parser.handle_response

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
