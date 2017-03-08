defmodule Mws.ProductTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start

    {:ok, conn} =
      %Mws.Config{
        endpoint:         Application.get_env(:mws, :endpoint),
        seller_id:        Application.get_env(:mws, :seller_id),
        marketplace_id:   Application.get_env(:mws, :marketplace_id),
        access_key_id:    Application.get_env(:mws, :access_key_id),
        secret_key:       Application.get_env(:mws, :secret_key),
        mws_auth_token:   Application.get_env(:mws, :mws_auth_token)
      }
      |> Mws.Client.start_link

    {:ok, conn: conn}
  end

  test "GetMatchingProduct [1]", ctx do
    use_cassette "get_matching_product" do
      resp = Mws.Product.get_matching_product(ctx[:conn], "B017R5CP1C")
      assert Enum.map(resp[:results], fn(r) -> r[:status] end) == ["Success"]
    end
  end

  test "GetMatchingProduct [M]", ctx do
    use_cassette "get_matching_products_multiple" do
      resp = Mws.Product.get_matching_product(ctx[:conn], ["B017R5CP1C", "B00KB1UUCQ"])
      assert Enum.map(resp[:results], fn(r) -> r[:status] end) == ["Success", "Success"]
      assert Enum.map(resp[:results], fn(r) -> r[:products] end) |> Enum.count == 2
    end
  end
end

