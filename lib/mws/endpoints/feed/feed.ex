defmodule Mws.Feed do

  def submit(conn, {feed_type, feed_content}) when is_atom(feed_type) and is_bitstring(feed_content) do
    query =
      %{
        "Action"            => "SubmitFeed",
        "Version"           => "2009-01-01",
        "FeedType"          => Mws.Parsers.FeedType.handle(feed_type),
        "PurgeAndReplace"   => false
      }

    url = %URI{
      path: "/Feeds/2009-01-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, feed_content, Mws.Parsers.FeedSubmissionInfo)
  end

  def list(conn, %{statuses: statuses, submission_ids: submission_ids, feed_types: feed_types}) do

    query =
      %{
        "Action"                   => "GetFeedSubmissionList",
        "Version"                  => "2009-01-01",
        "FeedTypeList"             => Enum.map(feed_types, &Mws.Parsers.FeedType.handle/1),
        "FeedSubmissionIdList"     => submission_ids,
        "FeedProcessingStatusList" => Enum.map(statuses, &Mws.Parsers.FeedStatus.handle/1)
      }
      |> Mws.Utils.restructure("FeedTypeList", "Type")
      |> Mws.Utils.restructure("FeedSubmissionIdList", "Id")
      |> Mws.Utils.restructure("FeedProcessingStatusList", "Status")

    url = %URI{
      path: "/Feeds/2009-01-01",
      query: query
    }

    Mws.Client.request(conn, :post, url, "", Mws.Parsers.FeedSubmissionList)
  end

end
