defmodule GsuiteCustomers do
  @moduledoc false

  NimbleCSV.define(CSV, [])

  def main() do
    customers =
      File.read!("gsuite_customers.json")
      |> Jason.decode!()
      |> Stream.map(fn %{"link" => link} ->
        link
        |> get_html()
        |> cutomer_html_to_list()
      end)
      |> Enum.into([])

    csv = CSV.dump_to_iodata(customers)

    File.write!("./customers.csv", csv)
  end

  def get_html(link) do
    %{"page" => page, "prefix" => prefix} = link

    url = "https://gsuite.google.com/customers" <> "/" <> prefix <> page <> ".html"

    %{body: html} = HTTPoison.get!(url, [], follow_redirect: true)

    {url, html}
  end

  defp about(document) do
    document
    |> Floki.find(".customer-info--about")
    |> Floki.text()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn str -> str != "" end)
    |> Enum.join(" ")
  end

  defp name(document) do
    document
    |> Floki.find(".customer--name")
    |> Floki.text()
    |> String.split(":")
    |> List.first()
    |> String.trim()
  end

  defp category(document) do
    document
    |> Floki.find(".customer-info--category")
    |> Floki.text()
    |> String.trim()
  end

  defp location(document) do
    document
    |> Floki.find(".customer-info--detail__address")
    |> Floki.text()
    |> String.trim()
  end

  defp website(document) do
    document
    |> Floki.find(".customer-info--detail__website")
    |> Floki.text()
    |> String.trim()
  end

  defp features(document) do
    document
    |> Floki.find(".customer-info--feature")
    |> Floki.text()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn str -> str != "" end)
    |> Enum.join(",")
  end

  def cutomer_html_to_list({url, html}) do
    document = Floki.parse_document!(html)

    [
      url,
      name(document),
      about(document),
      category(document),
      location(document),
      website(document),
      features(document)
    ]
  end
end
