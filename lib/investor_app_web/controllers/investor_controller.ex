defmodule InvestorAppWeb.InvestorController do
  use InvestorAppWeb, :controller
  alias InvestorApp.Investors
  alias InvestorApp.Investors.Investor

  def index(conn, _params) do
    changeset = Investors.change_investor(%Investor{})
    states = Enum.map(Investor.us_states(), &{&1, &1})
    render(conn, :index, changeset: changeset, states: states)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"investor" => investor_params, "file" => upload_file}) do
    # Get file size from the uploaded file
    %{size: file_size} = File.stat!(upload_file.path)

    # Check file size limit (3 MB)
    if file_size > 3 * 1024 * 1024 do
      conn
      |> put_flash(:error, "File size exceeds 3MB limit")
      |> redirect(to: ~p"/")
    else
      file_dir = Path.join([:code.priv_dir(:investor_app), "static", "uploads"])

      File.mkdir_p!(file_dir)

      timestamp =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.to_iso8601()
        |> String.replace("-", "")
        |> String.replace("T", "")
        |> String.replace(".", "")

      file_path = Path.join(file_dir, "#{timestamp}_#{upload_file.filename}")

      # Save the file
      File.cp!(upload_file.path, file_path)

      investor_params =
        Map.put(investor_params, "file_path", "/static/uploads/" <> Path.basename(file_path))

      case Investors.create_investor(investor_params) do
        {:ok, _investor} ->
          IO.inspect("Investor created successfully", label: "Success")

          conn
          |> put_flash(:info, "Investor created successfully")
          |> redirect(to: ~p"/")

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset.errors, label: "Changeset errors")

          conn
          |> put_flash(:error, "Failed to create investor: #{inspect(changeset.errors)}")
          |> redirect(to: ~p"/")
      end
    end
  end
end
