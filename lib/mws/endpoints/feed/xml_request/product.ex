defmodule Mws.Feed.XmlRequest.Product.DescriptionData do
  import XmlBuilder

  defstruct title: nil,
    brand: nil,
    description: nil,
    bullet_points: [],
    msrp_price: nil,
    msrp_currency: "USD",
    manufacturer: nil,
    item_type: nil

  def description_data(desc = %Mws.Feed.XmlRequest.Product.DescriptionData{}) do
    bullet_points = Enum.map(desc.bullet_points, &element(:BulletPoint, &1))
    element(:DescriptionData, [
      element(:Title, desc.title),
      element(:Brand, desc.brand),
      element(:Description, desc.description),
      element(:MSRP, %{currency: desc.msrp_currency}, desc.msrp_price),
      element(:Manufacturer, desc.manufacturer),
      element(:ItemType, desc.item_type)
    ] ++ bullet_points)
  end

end

defmodule Mws.Feed.XmlRequest.Product do
  import XmlBuilder

  defstruct sku: nil,
    asin: nil,
    product_tax_code: nil,
    description_data: [],
    product_data: []

  def product(prod = %Mws.Feed.XmlRequest.Product{}) do

    description_data =
      Enum.map(
        prod.description_data,
        &Mws.Feed.XmlRequest.Product.DescriptionData.description_data/1)

    product_data = []

    [element(:Product,
      [
        element(:SKU, prod.sku),
        element(:ProductTaxCode, prod.product_tax_code),
        element(:StandardProductID, [
              element(:Type, "ASIN"),
              element(:Value, prod.asin)
        ])
      ] ++ description_data ++ product_data
    )]
  end

  def message(product) when is_map(product),
  do: message([product])

  def message(products) when is_list(products) do
    %Mws.Feed.XmlRequest.Message{
      id: 1,
      operation_type: "Update",
      merchant_identifier: "M_EXAMPLE_123456",
      message_type: "Product",
      contents: products
    }
    |> Mws.Feed.XmlRequest.Message.message
  end

  def to_xml(prod = %Mws.Feed.XmlRequest.Product{}) do
    prod
    |> product
    |> message
    |> doc
  end

end
