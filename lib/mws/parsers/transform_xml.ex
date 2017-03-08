defmodule Mws.Parsers.TransformXml do

  @template Path.expand("./resources/strip_namespaces.xslt.xml")
  def transform_xml(doc) do
    filename =
      "./" <> produce_unique_filename()
      |> Path.expand

    with :ok        <- File.write(filename, doc),
         {:ok, xml} <- Xslt.transform(@template, filename),
         :ok        <- File.rm(filename),
         do: xml
  end

  defp produce_unique_filename() do
    Regex.replace(
      ~r/[\s\.\:]/,
      DateTime.to_iso8601(DateTime.utc_now()),
      ""
    ) <> ".xml"
  end

end
