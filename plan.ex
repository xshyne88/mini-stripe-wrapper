defmodule Stripe.Plan do
  @moduledoc false

  def url, do: "plans"

  def get_plans(params) do
    Stripe.Request.get(url(), params)
  end
end
