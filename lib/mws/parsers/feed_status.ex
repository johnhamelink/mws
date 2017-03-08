defmodule Mws.Parsers.FeedStatus do

  @feed_statuses %{
    awaiting_async_reply: "_AWAITING_ASYNCHRONOUS_REPLY_",
    cancelled: "_CANCELLED_",
    done: "_DONE_",
    in_progress: "_IN_PROGRESS_",
    in_safety_net: "_IN_SAFETY_NET_",
    submitted: "_SUBMITTED_",
    unconfirmed: "_UNCONFIRMED_"
  }

  def handle(raw) when is_bitstring(raw) do
    @feed_statuses
    |> Enum.map(fn({symbol, string}) -> {string, symbol} end)
    |> Enum.into(%{})
    |> Map.fetch!(raw)
  end

  def handle(atom) when is_atom(atom) do
    @feed_statuses
    |> Map.fetch!(atom)
  end

end
