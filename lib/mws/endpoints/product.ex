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

    Mws.Client.request(conn, :post, url)
  end

  def get_matching_product_for_id(conn, id, id_type \\ "ASIN")
  def get_matching_product_for_id(conn, id, id_type) when is_bitstring(id) do
    get_matching_product_for_id(conn, [id], id_type)
  end
  def get_matching_product_for_id(conn, ids, id_type) when is_list(ids) do
    query =
      %{
        "Action"   => "GetMatchingProductForId",
        "Version"  => "2011-10-01",
        "IdList" => ids,
        "IdType" => id_type
      }
      |> Mws.Utils.restructure("IdList", "Id")

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end

  def get_product_categories_for_asin(conn, asin) when is_bitstring(asin) do
    query =
      %{
        "Action"   => "GetCompetitivePricingForASIN",
        "Version"  => "2011-10-01",
        "ASIN" => asin
      }

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end

  def get_competitive_pricing_for_asin(conn, asin) when is_bitstring(asin) do
    get_competitive_pricing_for_asin(conn, [asin])
  end
  def get_competitive_pricing_for_asin(conn, asin) when is_list(asin) do
    query =
      %{
        "Action"   => "GetCompetitivePricingForASIN",
        "Version"  => "2011-10-01",
        "ASINList" => asins
      }
      |> Mws.Utils.restructure("ASINList", "ASIN")

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end
end
