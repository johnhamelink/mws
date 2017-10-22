defmodule Mws.Product do
  @doc """
  Lists products matching a given `search_term`. This can
  be optionally limited to a given `context`.

  ## Parameters

  - conn: pid of the client
  - search_term: String representing a standard amazon search term
  - context: String representing an amazon QueryContextId
  more here: http://docs.developer.amazonservices.com/en_UK/products/Products_QueryContextIDs.html
  defaults to "All"

  ## Examples

      iex> Mws.Product.list_matching_products(pid, "Harry potter")
      %{body: %{...}, %{header: %{...}}}
  """
  def list_matching_products(conn, search_term, context \\ "All") do
    query =
      %{
        "Action"         => "ListMatchingProducts",
        "Version"        => "2011-10-01",
        "Query"          => search_term,
        "QueryContextId" => context
      }

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)  
  end

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
        "Action"   => "GetProductCategoriesForASIN",
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
  def get_competitive_pricing_for_asin(conn, asins) when is_list(asins) do
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

  def get_my_fees_estimate(conn, request) when is_bitstring(request) do
    get_my_fees_estimate(conn, [request])
  end
  def get_my_fees_estimate(conn, request_list) when is_list(request_list) do
    query =
      %{
        "Action"   => "GetMyFeesEstimate",
        "Version"  => "2011-10-01",
        "FeesEstimateRequestList" => request_list
      }
      |> Mws.Utils.restructure("FeesEstimateRequestList", "FeesEstimateRequest")

    url = %URI{
      path: "/Products/2011-10-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end
end
