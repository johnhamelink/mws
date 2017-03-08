defmodule Mws.Parsers.FeedSubmissionList do
  import SweetXml

  # TODO: Handle HasNext somehow (I HATE XMLLLLLLLLL)
  def parse_xml(doc) do
      doc
      |> Mws.Parsers.TransformXml.transform_xml
      |> xpath(
        ~x"//GetFeedSubmissionListResponse",
        request_id: ~x".//ResponseMetadata/RequestId/text()"s,
        results: [
          ~x".//GetFeedSubmissionListResult"l,
          has_next: ~x".//HasNext/text()"  |> transform_by(&(&1 == "true")),
          feed_submission_id: ~x".//FeedSubmissionInfo/FeedSubmissionId/text()"s,
          feed_type: ~x".//FeedSubmissionInfo/FeedType/text()"s |> transform_by(&Mws.Parsers.FeedType.handle/1),
          submitted_date: ~x".//FeedSubmissionInfo/SubmittedDate/text()"s |> transform_by(&Mws.Parsers.DateTime.handle/1),
          feed_processing_status: ~x".//FeedSubmissionInfo/FeedProcessingStatus/text()"s |> transform_by(&Mws.Parsers.FeedStatus.handle/1)
        ]
      )
  end





end




