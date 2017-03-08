defmodule Mws.Parser do

  @moduledoc """
  """

  def handle_response({:ok, %{body: body, headers: headers, status_code: _code}}, parser) do
    case get_content_type(headers) do
      "text/xml" -> parser.parse_xml(body)
      "text/plain;charset="<> _charset ->
        body
        |> String.split("\r\n")
        |> CSV.decode(seperator: ?\t, headers: true)
    end
  end

  def get_content_type(headers) do
    Enum.find_value headers, fn
      {"Content-Type", value} -> value
      _ -> false
    end
  end
end
