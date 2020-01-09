defmodule Tax do
  @moduledoc """
  Calculate the taxes for different products

  # Example
    [
  %{"item" => "Oranges", "price" => "12.00", "quantity" => "10.00"},
  %{"item" => "Bananas", "price" => "3.00", "quantity" => "2.00"},
  %{"item" => "Wheatbix", "price" => "10.2", "quantity" => "1"}
    ]
  """

  def run(data) do
    data
    |> convert()
    |> calculate_multiple_items(0.08)
    |> total_price_and_tax()
  end

  def convert(items) do
    Enum.map(items, fn
      %{"item" => item, "price" => price, "quantity" => quantity} ->
        [item: item, price: to_number(price), quantity: quantity]
    end)
  end

  @doc "returns a list of [%{tax: number, total_and_tax: value}]"
  def calculate_multiple_items(list_of_items, tax) do
    Enum.map(
      list_of_items,
      fn [item: item, price: price, quantity: _] ->
        IO.inspect(base_tax(price, tax), label: "Result of last calculation")
      end
    )
  end

  def total_price_and_tax(list_of_items) do
    Enum.reduce(list_of_items, %{total: 0, tax_total: 0}, fn i, acc ->
      acc = %{total: acc.total + i.sub_total, tax_total: acc.tax_total + i.sub_tax}
    end)
  end

  defp to_number(string_number) do
    if Regex.match?(~r/^[\.]*/, string_number) do
      String.to_float(string_number)
    else
      String.to_integer(string_number)
    end
  end

  defp base_tax(item_price, tax) do
    calculated_tax = item_price * tax
    item_price + calculated_tax
    %{sub_total: item_price + calculated_tax, sub_tax: calculated_tax}
  end
end
