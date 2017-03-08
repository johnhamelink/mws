defmodule Mws.ProductTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start


    config = %Mws.Config{
      endpoint:         Application.get_env(:mws, :endpoint),
      seller_id:        Application.get_env(:mws, :seller_id),
      marketplace_id:   Application.get_env(:mws, :marketplace_id),
      access_key_id:    Application.get_env(:mws, :access_key_id),
      secret_key:       Application.get_env(:mws, :secret_key),
      mws_auth_token:   Application.get_env(:mws, :mws_auth_token)
    }

    {:ok, config: config}
  end

  test "GetMatchingProduct [1]", ctx do
    use_cassette "get_matching_product" do


      query =
        %{
          "Action"   => "GetMatchingProduct",
          "Version"  => "2011-10-01",
          "ASINList" => ["B017R5CP1C"]
        }
        |> Mws.Utils.restructure("ASINList", "ASIN")

      url = %URI{
        path: "/Products/2011-10-01",
        query: query
      }

      resp = Mws.Client.request(ctx[:config], {:post, url}, Mws.Parsers.Product)
      assert Enum.map(resp[:results], fn(r) -> r[:status] end) == ["Success"]
    end
  end

  test "GetMatchingProduct [M]", ctx do
    use_cassette "get_matching_products_multiple" do


      query =
        %{
          "Action"   => "GetMatchingProduct",
          "Version"  => "2011-10-01",
          "ASINList" => ["B017R5CP1C", "B00KB1UUCQ"]
        }
        |> Mws.Utils.restructure("ASINList", "ASIN")

      url = %URI{
        path: "/Products/2011-10-01",
        query: query
      }

    # TODO: modify the parser so that it handles multiple products correctly.
    resp = Mws.Client.request(ctx[:config], {:post, url}, Mws.Parsers.Product)

    assert Enum.map(resp[:results], fn(r) -> r[:status] end) == ["Success", "Success"]
    assert Enum.map(resp[:results], fn(r) -> r[:products] end) |> Enum.count == 2
   end
  end



end

