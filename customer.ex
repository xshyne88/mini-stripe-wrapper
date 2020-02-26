defmodule Stripe.Customer do
  @moduledoc false

  def url, do: "customers"
  def url(id), do: "customers/#{id}"

  def get(id, params) do
    url(id) |> Stripe.Request.get(params)
  end

  def create(params) do
    url() |> Stripe.Request.post(params)
  end

  def update(customer_id, params) do
    customer_id
    |> url()
    |> Stripe.Request.post(params)
  end
end
