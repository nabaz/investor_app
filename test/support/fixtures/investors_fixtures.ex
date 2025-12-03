defmodule InvestorApp.InvestorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InvestorApp.Investors` context.
  """

  @doc """
  Generate a investor.
  """
  # test/support/fixtures/investors_fixtures.ex
  def investor_fixture(attrs \\ %{}) do
    {:ok, investor} =
      attrs
      |> Enum.into(%{
        date_of_birth: ~D[1990-01-15],
        file_path: "/uploads/test.pdf",
        first_name: "John",
        last_name: "Doe",
        phone_number: "5551234567",
        state: "NY",
        street_address: "123 Main Street",
        zip_code: "10001"
      })
      |> InvestorApp.Investors.create_investor()

    investor
  end
end
