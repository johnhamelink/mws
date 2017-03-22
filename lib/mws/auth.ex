defmodule Mws.Auth do
  alias Mws.Utils

  def sign(config, {verb, uri}) do
    query =
      uri.query
      |> Enum.into(%{})
      |> Map.put("Timestamp", DateTime.to_iso8601(DateTime.utc_now))
      |> Map.put("AWSAccessKeyId", config.access_key_id)
      |> Map.put("SellerId", config.seller_id)
      |> Map.put("MarketplaceId", config.marketplace_id)
      |> Map.put("MWSAuthToken", config.mws_auth_token)
      |> Map.put("SignatureMethod", "HmacSHA256")
      |> Map.put("SignatureVersion", "2")
      |> Enum.sort
      |> Enum.filter(fn ({_k, v}) -> !is_nil(v) end)

    query ++ [
        Signature: build_signature(config, verb, uri, query)
    ] |> Utils.amz_encode_query
  end

  defp build_signature(config, verb, uri, query) do
    signature = [
      String.upcase("#{verb}"),
      uri.host,
      uri.path,
      Utils.amz_encode_query(query)
    ]
    |> Enum.join("\n")

    :crypto.hmac(:sha256, config.secret_key, signature)
    |> Base.encode64
  end

end
