defmodule Mws.Parsers.FeedSubmissionInfo do
  import SweetXml

  def parse_xml(doc) do
      doc
      |> Mws.Parsers.TransformXml.transform_xml
      |> xpath(
        ~x"//SubmitFeedResponse",
        request_id: ~x".//ResponseMetadata/RequestId/text()"s,
        results: [
          ~x".//SubmitFeedResult/FeedSubmissionInfo"l,
          feed_submission_id: ~x".//FeedSubmissionId/text()"s,
          feed_type: ~x".//FeedType/text()"s |> transform_by(&Mws.Parsers.FeedType.handle/1),
          submitted_date: ~x".//SubmittedDate/text()"s |> transform_by(&Mws.Parsers.DateTime.handle/1),
          feed_processing_status: ~x".//FeedProcessingStatus/text()"s |> transform_by(&Mws.Parsers.FeedStatus.handle/1)
        ]
      )
  end





end




