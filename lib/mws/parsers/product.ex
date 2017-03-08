defmodule Mws.Parsers.Product do
  import SweetXml

  def parse_xml(doc) do
    xml=
      doc
      |> Mws.Parsers.TransformXml.transform_xml

    xml
    |> xpath(
      ~x"//GetMatchingProductResponse",
      request_id: ~x".//ResponseMetadata/RequestId/text()"s,
      results: [
        ~x".//GetMatchingProductResult"l,
        status: ~x"./@status"s,
        products: [
          ~x".//Product"l,
          marketplace_id: ~x".//MarketplaceASIN/MarketplaceId/text()"s,
          asin: ~x".//MarketplaceASIN/ASIN/text()"s,
          relationships: [
            ~x".//Relationships"l,
            parent: [
              ~x".//VariationParent"o,
              marketplace_id: ~x".//Identifiers/MarketplaceASIN/MarketplaceId/text()"so,
              asin: ~x".//Identifiers/MarketplaceASIN/ASIN/text()"so,
            ],
            children: [
              ~x".//VariationChild"lo,
              marketplace_id: ~x".//Identifiers/MarketplaceASIN/MarketplaceId/text()"so,
              asin: ~x".//Identifiers/MarketplaceASIN/ASIN/text()"so,
            ]
          ],
          attributes: [
            ~x".//AttributeSets/ItemAttributes"l,
            binding: ~x".//Binding/text()"s,
            brand: ~x".//Brand/text()"so,
            color: ~x".//Color/text()"so,
            department: ~x".//Department/text()"so,
            features: ~x".//Feature/text()"slo,
            isMemorabilia: ~x".//IsMemorabilia/text()"so |> transform_by(&(&1 == "true")),
            label: ~x".//Label/text()"so,
            manufacturer: ~x".//Manufacturer/text()"so,
            model: ~x".//Model/text()"so,
            package_quantity: ~x".//PackageQuantity/text()"so,
            part_number: ~x".//PartNumber/text()"so,
            product_group: ~x".//ProductGroup/text()"so,
            product_type_name: ~x".//ProductTypeName/text()"so,
            publisher: ~x".//Publisher/text()"so,
            size: ~x".//Size/text()"so,
            studio: ~x".//Studio/text()"so,
            title: ~x".//Title/text()"so,
            list_price: [
              ~x".//ListPrice"l,
              amount: ~x".//Amount/text()"so,
              currency_code: ~x".//CurrencyCode/text()"so
            ],
            small_image: [
              ~x".//SmallImage"l,
              url: ~x".//URL/text()"so,
              height: [
                ~x".//Height",
                units: ~x"./@Units"so,
                size:  ~x"./text()"so
              ],
              width: [
                ~x".//Width",
                units: ~x"./@Units"so,
                size:  ~x"./text()"so
              ],
            ],
            item_dimensions: [
              ~x".//ItemDimensions"l,
              height: [
                ~x".//Height",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ],
              length: [
                ~x".//Length",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ],
              width: [
                ~x".//Width",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ]
            ],
            package_dimensions: [
              ~x".//PackageDimensions"l,
              height: [
                ~x".//Height",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ],
              length: [
                ~x".//Length",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ],
              width: [
                ~x".//Width",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ],
              weight: [
                ~x".//Weight",
                units: ~x"./@Units"so,
                size: ~x"./text()"so
              ]
            ]
          ]
        ]
      ]
    )
  end
end



