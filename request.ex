defmodule Stripe.Request do
  @moduledoc false

  use HTTPoison.Base

  import Stripe.Helpers, only: [snake_case: 1]
  import Stripe.Error, only: [process_poison_response: 1]

  @stripe_secret_key Application.get_env(:stripe_secret_key)
  @stripe_endpoint "https://api.stripe.com/v1/"

  def get(url, params \\ %{}) do
    url
    |> get(add_headers(:get), params: clamp_limit(params))
    |> process_poison_response()
  end

  def post(url, body \\ %{}) do
    url
    |> post(body, add_headers(:post))
    |> process_poison_response()
  end

  def delete(url, _params \\ %{}) do
    url
    |> delete(add_headers(:delete), [])
    |> process_poison_response()
  end

  defp add_headers(method, headers \\ %{}) do
    headers
    |> content_type_header(method)
    |> authorization_header()
  end

  def process_response(response) do
    response
  end

  defp content_type_header(headers, :get), do: json_content_type(headers)
  defp content_type_header(headers, :post), do: form_content_type(headers)
  defp content_type_header(headers, :delete), do: headers

  defp authorization_header(headers),
    do: Map.put(headers, "Authorization", "Bearer #{@stripe_secret_key}")

  defp json_content_type(headers), do: Map.put(headers, "Content-Type", "application/json")

  defp form_content_type(headers),
    do: Map.put(headers, "Content-Type", "application/x-www-form-urlencoded")

  defp clamp_limit(params = %{limit: limit}), do: Map.put(params, :limit, clamp(limit, 0, 100))
  defp clamp_limit(params), do: params

  def process_request_body(body) when is_map(body) or is_list(body), do: encode_body(body)
  def process_request_body(_), do: ""

  def process_url("/" <> path), do: process_url(path)
  def process_url(path), do: @stripe_endpoint <> path

  defp encode_body(body), do: Plug.Conn.Query.encode(body)

  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> snake_case()
  end

  def clamp(value, min, _max) when value < min, do: min
  def clamp(value, _min, max) when value > max, do: max
  def clamp(value, _min, _max), do: value
end
