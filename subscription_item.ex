defmodule Stripe.SubscriptionItem do
  @moduledoc false

  def url, do: "subscription_items"
  def url(id), do: url() <> "/#{id}"

  def update(subscription_item_id, %{quantity: _, prorate: _} = params) do
    params = get_update_params(params)

    Stripe.Request.post(url(subscription_item_id), params)
  end

  def update(_, _), do: {:error, "provide plan and quantity"}

  def get_create_params(%{plan_id: plan_id, quantity: quantity}) do
    %{
      "plan" => plan_id,
      "quantity" => quantity
    }
  end

  defp get_update_params(%{quantity: quantity} = params) do
    %{
      "prorate" => Map.get(params, :prorate, true),
      "quantity" => quantity
    }
  end
end
