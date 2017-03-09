defmodule Mws.Feed do
  @version "2009-01-01"

  def submit(conn, {feed_type, feed_content}) when is_bitstring(feed_content) do
    query =
      %{
        "Action"            => "SubmitFeed",
        "Version"           => @version,
        "FeedType"          => feed_type,
        "PurgeAndReplace"   => false
      }

    url = %URI{
      path: "/Feeds/2009-01-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, feed_content)
  end

  def list(conn, %{statuses: statuses, submission_ids: submission_ids, feed_types: feed_types}) do

    query =
      %{
        "Action"                   => "GetFeedSubmissionList",
        "Version"                  => @version,
        "FeedTypeList"             => feed_types,
        "FeedSubmissionIdList"     => submission_ids,
        "FeedProcessingStatusList" => statuses
      }
      |> Mws.Utils.restructure("FeedTypeList", "Type")
      |> Mws.Utils.restructure("FeedSubmissionIdList", "Id")
      |> Mws.Utils.restructure("FeedProcessingStatusList", "Status")

    url = %URI{
      path: "/Feeds/2009-01-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, "")
  end

  def result(conn, %{submission_id: submission_id}) do
    query =
      %{
        "Action"           => "GetFeedSubmissionResult",
        "Version"          => @version,
        "FeedSubmissionId" => submission_id
      }

    url = %URI{
      path: "/Feeds/2009-01-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, "")
  end

end
