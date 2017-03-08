defmodule Mws.Parsers.DateTime do

  def handle(raw) when is_bitstring(raw) do
    {:ok, datetime, _} = DateTime.from_iso8601(raw)
    datetime
  end

end
