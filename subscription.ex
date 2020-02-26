defmodule Stripe.Subscription do
  @moduledoc false

  def url, do: "subscriptions"
  def url(id), do: url() <> "/#{id}"

  def create(%{customer: _} = params) do
    params = get_create_params(params)

    Stripe.Request.post(url(), params)
  end

  def create(_), do: {:error, "please provide customer"}

  def renew(%{customer: _} = params) do
    params = get_renew_params(params)

    Stripe.Request.post(url(), params)
  end

  def renew(_), do: {:error, "please provide customer"}

  def cancel(subscription_id, params) do
    params = get_cancel_params(params)

    Stripe.Request.delete(url(subscription_id), params)
  end

  defp get_renew_params(params), do: params |> get_create_params()

  defp get_create_params(%{customer: customer_id} = params) do
    %{
      "customer" => customer_id,
      "items" => %{
        0 => Stripe.SubscriptionItem.get_create_params(params)
      }
    }
    |> maybe_has_billing_cycle_anchor(params)
  end

  def get_update_params(params) do
    %{
      "items" => %{
        0 => Stripe.SubscriptionItem.get_create_params(params)
      }
    }
  end

  defp get_cancel_params(params) do
    params |> Map.take([:invoice_now, :prorate])
  end

  defp maybe_has_billing_cycle_anchor(params, %{billing_cycle_anchor: anchor}) do
    Map.put(params, :billing_cycle_anchor, anchor)
  end

  defp maybe_has_billing_cycle_anchor(params, _), do: params
end
