defmodule Mws.Parsers.FeedSubmissionResult do
  import SweetXml

  def parse_xml(doc) do
      doc
      |> Mws.Parsers.TransformXml.transform_xml
      |> IO.puts
  end
end




