defmodule Mws.Parsers.FeedStatusTest do
  use ExUnit.Case, async: false

  test "String -> Atom -> String" do
    assert Mws.Parsers.FeedStatus.handle("_DONE_") == :done
    assert Mws.Parsers.FeedStatus.handle(:done) == "_DONE_"
  end
end
