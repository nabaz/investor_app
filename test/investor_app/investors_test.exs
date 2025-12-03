defmodule InvestorApp.InvestorsTest do
  use InvestorApp.DataCase

  alias InvestorApp.Investors

  describe "investors" do
    alias InvestorApp.Investors.Investor

    import InvestorApp.InvestorsFixtures

    @invalid_attrs %{
      state: nil,
      first_name: nil,
      last_name: nil,
      date_of_birth: nil,
      phone_number: nil,
      street_address: nil,
      zip_code: nil,
      file_path: nil
    }

    test "list_investors/0 returns all investors" do
      investor = investor_fixture()
      assert Investors.list_investors() == [investor]
    end

    test "get_investor!/1 returns the investor with given id" do
      investor = investor_fixture()
      assert Investors.get_investor!(investor.id) == investor
    end

    test "create_investor/1 with valid data creates a investor" do
      valid_attrs = %{
        state: "NY",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: ~D[1990-01-15],
        phone_number: "5551234567",
        street_address: "123 Main Street",
        zip_code: "10001",
        file_path: "/uploads/test.pdf"
      }

      assert {:ok, %Investor{} = investor} = Investors.create_investor(valid_attrs)
      assert investor.state == "NY"
      assert investor.first_name == "John"
      assert investor.last_name == "Doe"
      assert investor.date_of_birth == ~D[1990-01-15]
      assert investor.phone_number == "5551234567"
      assert investor.street_address == "123 Main Street"
      assert investor.zip_code == "10001"
      assert investor.file_path == "/uploads/test.pdf"
    end

    test "create_investor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Investors.create_investor(@invalid_attrs)
    end

    test "change_investor/1 returns a investor changeset" do
      investor = investor_fixture()
      assert %Ecto.Changeset{} = Investors.change_investor(investor)
    end
  end
end
