defmodule Mws.ClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "Can make a connection to MWS" do
    use_cassette "get_matching_product" do

      config = %Mws.Config{
        endpoint:         Application.get_env(:mws, :endpoint),
        seller_id:        Application.get_env(:mws, :seller_id),
        marketplace_id:   Application.get_env(:mws, :marketplace_id),
        access_key_id:    Application.get_env(:mws, :access_key_id),
        secret_key:       Application.get_env(:mws, :secret_key),
        mws_auth_token:   Application.get_env(:mws, :mws_auth_token)
      }

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

    resp = Mws.Client.request(config, {:post, url}, Mws.Parsers.Product)
    assert resp[:results] |> List.first |> Map.fetch!(:status) == "Success"
   end
  end
end

