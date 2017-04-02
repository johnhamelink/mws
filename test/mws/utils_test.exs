defmodule Mws.UtilsTest do
  use ExUnit.Case
  alias Mws.Utils

  test "percent encodes query" do
    assert Utils.amz_encode_query(%{"term" => "foo bar"}) == "term=foo%20bar"
  end

  test "encodes nested queries and preserves order" do
    query = [
      MarketplaceId: "123",
      IdType: "ASIN",
      IdValue: "ABC",
      Identifier: "ABC",
      IsAmazonFulfilled: true,
      PriceToEstimateFees: [
        ListingPrice: [
          CurrencyCode: "GBP",
          Amount: 0
        ]
      ]
    ]
    expected = "MarketplaceId=123&IdType=ASIN&IdValue=ABC&Identifier=ABC&IsAmazonFulfilled=true&PriceToEstimateFees.ListingPrice.CurrencyCode=GBP&PriceToEstimateFees.ListingPrice.Amount=0"
    assert Utils.amz_encode_query(query) == expected
  end

  test "structure replaces params with numbered params" do
    result =
      %{"List" => ["term1", "term2"]}
      |> Utils.restructure("List", "Id")
    assert result == %{"List.Id.1" => "term1", "List.Id.2" => "term2"}
  end

  test "structure works with one item" do
    result = %{"List" => ["term1"]} |> Utils.restructure("List", "Id")
    assert result == %{"List.Id.1" => "term1"}
  end

  test "structure does nothing with zero item" do
    result = %{"List" => nil} |> Utils.restructure("List", "Id")
    assert result == %{}
    result = %{"List" => []} |> Utils.restructure("List", "Id")
    assert result == %{}
  end

end
