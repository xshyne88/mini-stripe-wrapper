defmodule Stripe.Invoice do
  @moduledoc false

  def url, do: "invoices"
  def url(id), do: url() <> "/#{id}"
  def finalize_url(id), do: url(id) <> "/finalize"
  def pay_url(id), do: url(id) <> "/pay"
  def upcoming_url(), do: url() <> "/upcoming"

  def create(%{customer: customer_id}) do
    Stripe.Request.post(url(), %{customer: customer_id})
  end

  def create(_), do: {:error, "customer field not provided"}

  def get(id, params) do
    Stripe.Request.get(url(id), params)
  end

  def get_invoices(params) do
    Stripe.Request.get(url(), params)
  end

  def get_upcoming(params) do
    Stripe.Request.get(upcoming_url(), params)
  end

  def finalize(id, params) do
    Stripe.Request.post(finalize_url(id), params)
  end

  def pay(id, params) do
    Stripe.Request.post(pay_url(id), params)
  end
end
