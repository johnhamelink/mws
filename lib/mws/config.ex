defmodule Mws.Config do
  defstruct endpoint: nil,
            seller_id: nil,
            marketplace_id: nil,
            access_key_id: nil,
            secret_key: nil,
            mws_auth_token: nil


  def endpoint(:europe),        do: %URI{scheme: "https", host: "mws-eu.amazonservices.com"}
  def endpoint(:north_america), do: %URI{scheme: "https", host: "mws.amazonservices.com"}
  def endpoint(:india),         do: %URI{scheme: "https", host: "mws.amazonservices.in"}
  def endpoint(:china),         do: %URI{scheme: "https", host: "mws.amazonservices.com.cn"}
  def endpoint(:japan),         do: %URI{scheme: "https", host: "mws.amazonservices.jp"}

  def endpoints do
    [:europe, :north_america, :india, :china, :japan]
  end

end
