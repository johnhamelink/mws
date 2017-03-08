defmodule Mws.Utils do

  @moduledoc """
  Based on https://github.com/homanchou/elixir-amazon-mws-client
  """

  def amz_encode_query(query_map) do
    Enum.map_join(query_map, "&", &pair/1)
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
  def numbered_params(key, list) do
    Enum.with_index(list, 1)
    |> Enum.reduce(%{}, fn {value, index}, acc ->
      Map.merge(acc, %{"#{key}.#{index}" => value})
    end)
  end

end
