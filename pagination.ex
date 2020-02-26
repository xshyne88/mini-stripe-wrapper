defmodule Stripe.Pagination do
  @moduledoc false

  def convert_to_stripe_pagination(pagination) do
    pagination =
      pagination
      |> add_include_total_count!()
      |> set_limit()
      |> set_starting_after()
      |> set_ending_before()

    {:ok, pagination}
  end

  defp set_limit(%{first: first} = args) do
    args
    |> Map.put(:limit, first)
    |> Map.delete(:first)
  end

  defp set_starting_after(%{after: starting_after} = args) do
    args
    |> Map.put(:starting_after, starting_after |> Base.decode64!())
    |> Map.delete(:after)
  end

  defp set_starting_after(args), do: args

  defp set_ending_before(%{before: ending_before} = args) do
    args
    |> Map.put(:ending_before, ending_before |> Base.decode64!())
    |> Map.delete(:before)
  end

  defp set_ending_before(args), do: args

  def add_include_total_count!(map) do
    Map.put(map, "include[]", "total_count")
  end

  def add_include_total_count(map) do
    {:ok, add_include_total_count!(map)}
  end
end
