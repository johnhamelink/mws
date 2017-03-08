defmodule Mws.Product do

  def get_matching_product(conn, asin) when is_bitstring(asin),
  do: get_matching_product(conn, [asin])

  def get_matching_product(conn, asins) when is_list(asins) do
    query =
      %{
        "Action"   => "GetMatchingProduct",
        "Version"  => "2011-10-01",
        "ASINList" => asins
      }
      |> Mws.Utils.restructure("ASINList", "ASIN")

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, Mws.Parsers.Product)
  end

end
