defmodule Mws.Utils do

  @moduledoc """
  Based on https://github.com/homanchou/elixir-amazon-mws-client
  """

  # The Orders API require the MarketplaceId as a list.
  def prepare_query(query, "/Orders/2013-09-01"),
  do: Mws.Utils.restructure(query, "MarketplaceId", "Id")

  def prepare_query(query, _), do: query

  def amz_encode_query(query_map) do
    Enum.map_join(query_map, "&", &pair/1)
  end

  def pair({outer_key, list}) when is_list(list) do
    Enum.map_join(list, "&", fn ({inner_key, value}) ->
      pair({"#{outer_key}.#{inner_key}", value})
    end)
  end
  def pair({k, v}) do
    URI.encode(to_string(k), &URI.char_unreserved?/1) <>
    "=" <>
    URI.encode(to_string(v), &URI.char_unreserved?/1)
  end

  def restructure(params, prefix, appendage) do
    {list, params} = Map.pop(params, prefix)
    Map.merge(params, numbered_params("#{prefix}.#{appendage}", list))
  end

  # Takes a map of params, removes a key and with the values of that key, should
  # it be a list, enumerates over each element in the list and puts them back
  # into the map with key of "prefix.appendage.element_index"
  def numbered_params(_, nil), do: %{}
  # Convert Strings into a 1-element list
  def numbered_params(key, str) when is_bitstring(str),
  do: numbered_params(key, [str])
  def numbered_params(key, list) when is_list(list) do
    Enum.with_index(list, 1)
    |> Enum.reduce(%{}, fn {value, index}, acc ->
      Map.merge(acc, %{"#{key}.#{index}" => value})
    end)
  end

end
