defmodule Stripe.Error do
  @moduledoc """
  200 - OK	Everything worked as expected.
  400 - Bad Request	The request was unacceptable, often due to missing a required parameter.
  401 - Unauthorized	No valid API key provided.
  402 - Request Failed	The parameters were valid but the request failed.
  404 - Not Found	The requested resource doesn't exist.
  409 - Conflict	The request conflicts with another request (perhaps due to using the same idempotent key).
  429 - Too Many Requests	Too many requests hit the API too quickly.
  500, 502, 503, 504 - Server Errors	Something went wrong on Stripe's end. (These are rare.)
  """
  require Logger

  defstruct ~w(
    charge
    code
    decline_code
    doc_url
    status_code
    message
    param
    payment_intent
    payment_method
    type
 )a

  def new(params) do
    params = params |> Map.update(:message, nil, &process_message(&1))

    struct(__MODULE__, params)
  end

  def process_poison_response({:ok, %HTTPoison.Response{status_code: 200} = response}),
    do: {:ok, response}

  def process_poison_response({:ok, %HTTPoison.Response{body: %{error: _error}} = response}),
    do: stripe_error(response)

  def process_poison_response({:error, %HTTPoison.Error{reason: reason}}),
    do: {:error, process_reason(reason)}

  def stripe_error(%HTTPoison.Response{body: %{error: error}, status_code: status_code}) do
    error = error |> Map.put(:status_code, status_code)

    {:ok, new(error)}
  end

  defp process_reason(reason) do
    case reason do
      :nxdomain -> "url address was not found"
      :timeout -> "http timeout"
      reason -> "reason: #{reason} occurred"
    end
  end

  defp process_message(message) do
    case message do
      "No such token: " <> _token_id ->
        "token was null or not found in stripe database"

      "No such subscription: " <> _subscription_id ->
        "subscription id was null or not found in stripe database"

      "No such customer: " <> _customer_id ->
        "customer id was null or found in stripe database"

      _ ->
        message
    end
  end
end
