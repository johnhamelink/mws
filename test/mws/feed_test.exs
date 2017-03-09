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
    xml = File.read!("test/fixture/feeds/submit_feed.xml")

    use_cassette "submit_product_feed" do
      resp = Mws.Feed.submit(ctx[:conn], {"_POST_PRODUCT_DATA_", xml})
      assert get_in(resp, ["SubmitFeedResponse", "SubmitFeedResult", "FeedSubmissionInfo", "FeedProcessingStatus"]) == "_SUBMITTED_"
    end
  end

  test "GetFeedSubmissionList", ctx do
    use_cassette "get_feed_submission_list" do

      list = Mws.Feed.list(
        ctx[:conn],
        %{
          statuses: [:done],
          submission_ids: ["50004017233"],
          feed_types: [:products, :product_pricing]
        }
      )

      assert get_in(list, ["GetFeedSubmissionListResponse", "GetFeedSubmissionListResult", "FeedSubmissionInfo", "FeedProcessingStatus"]) == "_IN_PROGRESS_"
    end
  end

  test "GetFeedSubmissionResult", ctx do
    use_cassette "get_feed_submission_result" do

      result = Mws.Feed.result(
        ctx[:conn],
        %{submission_id: "50005017234"}
      )

      refute get_in(result, ["AmazonEnvelope", "Message", "ProcessingReport", "Result"]) |> List.first |> Map.fetch!("ResultCode") == "Error"
    end
  end
end
