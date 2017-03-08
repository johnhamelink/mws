defmodule Mws.FeedTest do
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

  test "SubmitFeed", ctx do
    xml =
      %Mws.Feed.XmlRequest.Product{
        sku: "56789",
        asin: "B0EXAMPLEG",
        product_tax_code: "A_GEN_NOTAX",
        description_data: [
          %Mws.Feed.XmlRequest.Product.DescriptionData{
            title: "Example Product Title",
            brand: "Example Product Brand",
            description: "Example Product Description",
            bullet_points: ["Bullet 1", "Bullet 2", "Bullet 3"],
            msrp_price: "25.19",
            msrp_currency: "USD",
            manufacturer: "Example Product Manufacturer",
            item_type: "example-item-type"
          }
        ]
      }
      |> Mws.Feed.XmlRequest.Product.to_xml

    use_cassette "submit_product_feed" do
      resp = Mws.Feed.submit(ctx[:conn], {:products, xml})
      assert resp.results |> List.first |> Map.fetch!(:feed_processing_status) == :submitted
    end
  end

  test "GetFeedSubmissionList", ctx do
    use_cassette "get_feed_submission_list" do

      Mws.Feed.list(
        ctx[:conn],
        %{
          statuses: [:done],
          submission_ids: ["50004017233"],
          feed_types: [:products, :product_pricing]
        }
      )
      |> IO.inspect

    end
  end
end
