defmodule Mws.Order do

  defstruct "Action":              "ListOrders",
            "Version":             "2013-09-01",
            "CreatedAfter":        nil,
            "CreatedBefore":       Timex.now,
            "LastUpdatedAfter":    nil,
            "LastUpdatedBefore":   Timex.now,
            "OrderStatus":         ~w(PendingAvailability Pending Unshipped PartiallyShipped Shipped InvoiceUnconfirmed Canceled Unfulfillable),
            "FulfillmentChannel":  ~w(AFN MFN),
            "BuyerEmail":          nil,
            "SellerOrderId":       nil,
            "MaxResultsPerPage":   100


  @doc """
  Use this to retrieve a list of orders
  """
  def list(conn, params = %Mws.Order{}) do
    query =
      params
      |> Map.from_struct
      |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
      |> Mws.Utils.restructure("OrderStatus", "Status")
      |> Mws.Utils.restructure("FulfillmentChannel", "Channel")

    url = %URI{
      path: "/Orders/2013-09-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end

  @doc """
  Use this to get the items an order contains
  """
  def list_items(conn, order_id) when is_bitstring(order_id) do
    query = %{
        "Action"        => "ListOrderItems",
        "Version"       => "2013-09-01",
        "AmazonOrderId" => order_id
    }

    url = %URI{
      path: "/Orders/2013-09-01",
      query: query
    }

    Mws.Client.request(conn, :post, url)
  end

end
