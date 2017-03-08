defmodule Mws.Parsers.FeedType do

  @feed_types %{
    # Products
    products: "_POST_PRODUCT_DATA_",
    product_inventory: "_POST_INVENTORY_AVAILABILITY_DATA_",
    product_overrides: "_POST_PRODUCT_OVERRIDES_DATA_",
    product_pricing: "_POST_PRODUCT_PRICING_DATA_",
    product_images: "_POST_PRODUCT_IMAGE_DATA_",
    product_relationships: "_POST_PRODUCT_RELATIONSHIP_DATA_",
    product_flat_file_inventory_loader: "_POST_FLAT_FILE_INVLOADED_DATA_",
    product_flat_file_listings: "_POST_FLAT_FILE_LISTINGS_DATA",
    product_flat_file_book_loader: "_POST_FLAT_FILE_BOOKLOADER_DATA_",
    product_flat_file_music_loader: "_POST_FLAT_FILE_CONVERGENCE_LISTINGS_DATA_",
    product_flat_file_video_loader: "_POST_FLAT_FILE_LISTINGS_DATA_",
    product_flat_file_price_and_quantity_update: "_POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA_",
    product_uiee_inventory: "_POST_UIEE_BOOKLOADER_DATA_",
    product_aces_3_data: "_POST_STD_ACES_DATA_",

    # Orders
    order_acknowledgements: "_POST_ORDER_ACKNOWLEDGEMENT_DATA_",
    order_adjustments: "_POST_PAYMENT_ADJUSTMENT_DATA_",
    order_fulfillments: "_POST_ORDER_FULFILLMENT_DATA_",
    order_invoice_confirmations: "_POST_INVOICE_CONFIRMATION_DATA_",
    order_flat_file_acknowledgements: "_POST_FLAT_FILE_ORDER_ACKNOWLEDGEMENT_DATA_",
    order_flat_file_adjustments: "_POST_FLAT_FILE_PAYMENT_ADJUSTMENT_DATA_",
    order_flat_file_fulfillments: "_POST_FLAT_FILE_FULFILLMENT_DATA_",
    order_flat_file_invoice_confirmations: "_POST_FLAT_FILE_INVOICE_CONFIRMATION_DATA_",

    # Fulfillment By Amazon (FBA)
    fba_fulfillment_orders: "_POST_FULFILLMENT_ORDER_REQUEST_DATA_",
    fba_fulfillment_order_cancellations: "_POST_FULFILLMENT_ORDER_CANCELLATION_REQUEST_DATA_",
    fba_inbound_shipment_carton_information: "_POST_FBA_INBOUND_CARTON_CONTENTS_",
    fba_flat_file_fulfillment_orders: "_POST_FLAT_FILE_FULFILLMENT_ORDER_REQUEST_DATA_",
    fba_flat_file_fulfillment_order_cancellations: "_POST_FLAT_FILE_FULFILLMENT_ORDER_CANCELLATION_REQUEST_DATA_",
    fba_flat_file_create_inbound_shipment_plan: "_POST_FLAT_FILE_FBA_CREATE_INBOUND_PLAN_",
    fba_flat_file_update_inbound_shipment_plan: "_POST_FLAT_FILE_FBA_UPDATE_INBOUND_PLAN_",
    fba_flat_file_create_removal_feed: "_POST_FLAT_FILE_FBA_CREATE_REMOVAL_"
  }

  def handle(raw) when is_bitstring(raw) do
    @feed_types
    |> Enum.map(fn({symbol, string}) -> {string, symbol} end)
    |> Enum.into(%{})
    |> Map.fetch!(raw)
  end

  def handle(atom) when is_atom(atom) do
    @feed_types
    |> Map.fetch!(atom)
  end

end
