defmodule Mws.Parsers.TransformXml do

  # TODO: Somehow use XSLT to transform the document correctly, or xmerl_xs
  #       transforms and feed them into SweetXml somehow.
  def transform_xml(doc) do
    doc
    |> String.replace("<ns2:", "<")
    |> String.replace("</ns2:", "</")
  end
end
