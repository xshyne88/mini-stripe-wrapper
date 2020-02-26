defmodule Stripe do
  @moduledoc false

  alias Stripe.{
    Customer,
    Invoice,
    Plan,
    Subscription,
    SubscriptionItem
  }

  # CUSTOMER

  defdelegate get_customer(id, params \\ %{}), to: Customer, as: :get

  defdelegate create_customer(params \\ %{}), to: Customer, as: :create

  defdelegate update_customer(id, params \\ %{}), to: Customer, as: :update

  # SUBSCRIPTION

  defdelegate create_subscription(params \\ %{}), to: Subscription, as: :create

  defdelegate renew_subscription(params \\ %{}), to: Subscription, as: :renew

  defdelegate cancel_subscription(id, params \\ %{}), to: Subscription, as: :cancel

  defdelegate update_subscription_item(id, params \\ %{}), to: SubscriptionItem, as: :update

  # INVOICE

  defdelegate get_invoice(id, paras \\ %{}), to: Invoice, as: :get

  defdelegate create_invoice(params \\ %{}), to: Invoice, as: :create

  defdelegate finalize_invoice(id, params \\ %{}), to: Invoice, as: :finalize

  defdelegate pay_invoice(id, params \\ %{}), to: Invoice, as: :pay

  defdelegate get_upcoming(params \\ %{}), to: Invoice, as: :get_upcoming

  defdelegate get_invoices(params \\ %{}), to: Invoice, as: :get_invoices

  # PLAN

  defdelegate get_plans(params \\ %{}), to: Plan, as: :get_plans
end
