defmodule Mws.Parsers.ProductTest do
  use ExUnit.Case, async: false

  test "Cycling Gloves" do
    response =
      File.read!("test/fixture/xml_responses/product/cycling_gloves.xml")
      |> Mws.Parsers.Product.parse_xml

    assert response[:status] == "Success"
    product = response[:products] |> List.first
    assert get_in(product, [:asin]) == "B017R5CP1CB0186SA9EE"

    all = fn :get, data, next -> Enum.map(data, next) end
    assert get_in(product, [:attributes, all, :features]) |> List.first |> Enum.count == 6
    assert product[:relationships] |> List.first |> Map.fetch!(:children)  |> Enum.count == 0
    assert product[:relationships] |> List.first |> Map.fetch!(:parent) |> is_map
  end

  test "MWS documentation example" do
    response =
      File.read!("test/fixture/xml_responses/product/mws_doc_example.xml")
      |> Mws.Parsers.Product.parse_xml

    assert response[:status] == "Success"
    product = response[:products] |> List.first
    assert get_in(product, [:asin]) == "B002KT3XRQB002KT3XQCB002KT3XQWB002KT3XQMB002KT3XR6B002KT3XRG"

    all = fn :get, data, next -> Enum.map(data, next) end
    assert get_in(product, [:attributes, all, :features]) |> List.first |> Enum.count == 5
    assert product[:relationships] |> List.first |> Map.fetch!(:children)  |> Enum.count == 5
    refute product[:relationships] |> List.first |> Map.fetch!(:parent)
  end

end
