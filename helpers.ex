defmodule Stripe.Helpers do
  @moduledoc false

  def get_response_body(%HTTPoison.Response{body: body}), do: {:ok, body}
  def get_response_body(%Stripe.Error{} = error), do: {:error, error}
  def get_response_body(_), do: {:error, "could not retrieve body from response"}

  def snake_case(map) when is_map(map) do
    map
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.put(acc, snake_case_key(key), snake_case(value))
    end)
  end

  def snake_case(map) when is_list(map), do: Enum.map(map, &snake_case/1)
  def snake_case(map), do: map

  defp snake_case_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp snake_case_key(key) when is_binary(key) do
    key
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp snake_case_key(key), do: key

  def atomize_keys(nil), do: nil

  def atomize_keys(%{} = map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
  end

  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map), do: not_a_map
end
