defmodule InvestorApp.Investors.Investor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "investors" do
    field :first_name, :string
    field :last_name, :string
    field :date_of_birth, :date
    field :phone_number, :string
    field :street_address, :string
    field :state, :string
    field :zip_code, :string
    field :file_path, :string

    timestamps(type: :utc_datetime)
  end

  @us_state ~w(AL AK AZ AR CA CO CT DE FL GA HI ID IL
  IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC
  ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)

  @doc false
  def changeset(investor, attrs) do
    investor
    |> cast(attrs, [
      :first_name,
      :last_name,
      :date_of_birth,
      :phone_number,
      :street_address,
      :state,
      :zip_code,
      :file_path
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :date_of_birth,
      :phone_number,
      :street_address,
      :state,
      :zip_code,
      :file_path
    ])
    |> validate_inclusion(:state, @us_state, message: "must be a valid US state")
  end
end
