defmodule Mws.Feed.XmlRequest.Message do
  import XmlBuilder

  defstruct id: 1,
    operation_type: nil,
    merchant_identifier: nil,
    message_type: nil,
    contents: []

  # TODO: Add validation for operation type
  @operation_types %{
    update: "Update",
    delete: "Delete",
    partial_update: "PartialUpdate"
  }

  @namespaces %{
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd"
  }

  def message(msg = %Mws.Feed.XmlRequest.Message{}) do
    message = [
      element(:MessageID, msg.id),
      element(:OperationType, msg.operation_type)
    ] ++ msg.contents

    element(:AmazonEnvelope, @namespaces, [
      element(:Header, [
        element(:DocumentVersion, "1.01"),
        element(:MerchantIdentifier, msg.merchant_identifier) # Is this the SellerID?
      ]),
      element(:MessageType, msg.message_type),
      element(:PurgeAndReplace, "false"),
      element(:Message, message)
    ])
  end

end
