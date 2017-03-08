defmodule Mws.Parsers.FeedTypeTest do
  use ExUnit.Case, async: false

  test "String -> Atom -> String" do
    assert Mws.Parsers.FeedType.handle("_POST_ORDER_FULFILLMENT_DATA_") == :order_fulfillments
    assert Mws.Parsers.FeedType.handle(:order_fulfillments) == "_POST_ORDER_FULFILLMENT_DATA_"
  end
end
