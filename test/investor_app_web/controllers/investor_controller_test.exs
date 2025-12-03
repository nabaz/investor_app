defmodule InvestorAppWeb.InvestorControllerTest do
  use InvestorAppWeb.ConnCase

  describe "GET /" do
    test "renders the investor form", %{conn: conn} do
      conn = get(conn, ~p"/")

      assert html_response(conn, 200) =~ "Investor Data Management"
      assert html_response(conn, 200) =~ "First Name"
      assert html_response(conn, 200) =~ "Submit Investor Data"
    end

    test "includes all US states in the dropdown", %{conn: conn} do
      conn = get(conn, ~p"/")

      assert html_response(conn, 200) =~ "NY"
      assert html_response(conn, 200) =~ "CA"
      assert html_response(conn, 200) =~ "TX"
    end
  end

  describe "POST /investors" do
    test "creates investor with valid data and file", %{conn: conn} do
      upload = %Plug.Upload{
        path: create_temp_file("test content"),
        filename: "test_doc.pdf",
        content_type: "application/pdf"
      }

      investor_params = %{
        "first_name" => "John",
        "last_name" => "Doe",
        "date_of_birth" => "1990-01-15",
        "phone_number" => "5551234567",
        "street_address" => "123 Main Street",
        "state" => "NY",
        "zip_code" => "10001"
      }

      conn = post(conn, ~p"/investors", %{"investor" => investor_params, "file" => upload})

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Investor created successfully"
    end

    test "rejects file larger than 3MB", %{conn: conn} do
      # Create a file larger than 3MB
      large_content = String.duplicate("x", 3 * 1024 * 1024 + 1)

      upload = %Plug.Upload{
        path: create_temp_file(large_content),
        filename: "large_file.pdf",
        content_type: "application/pdf"
      }

      investor_params = %{
        "first_name" => "John",
        "last_name" => "Doe",
        "date_of_birth" => "1990-01-15",
        "phone_number" => "5551234567",
        "street_address" => "123 Main Street",
        "state" => "NY",
        "zip_code" => "10001"
      }

      conn = post(conn, ~p"/investors", %{"investor" => investor_params, "file" => upload})

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "File size exceeds 3MB limit"
    end

    test "returns error with invalid investor data", %{conn: conn} do
      upload = %Plug.Upload{
        path: create_temp_file("test content"),
        filename: "test_doc.pdf",
        content_type: "application/pdf"
      }

      invalid_params = %{
        "first_name" => "",
        "last_name" => "",
        "date_of_birth" => "",
        "phone_number" => "",
        "street_address" => "",
        "state" => "INVALID",
        "zip_code" => "abc"
      }

      conn = post(conn, ~p"/investors", %{"investor" => invalid_params, "file" => upload})

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Failed to create investor"
    end

    test "returns error with invalid zip code format", %{conn: conn} do
      upload = %Plug.Upload{
        path: create_temp_file("test content"),
        filename: "test_doc.pdf",
        content_type: "application/pdf"
      }

      investor_params = %{
        "first_name" => "John",
        "last_name" => "Doe",
        "date_of_birth" => "1990-01-15",
        "phone_number" => "5551234567",
        "street_address" => "123 Main Street",
        "state" => "NY",
        "zip_code" => "1234"  # only 4 digits should be invalid
      }

      conn = post(conn, ~p"/investors", %{"investor" => investor_params, "file" => upload})

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "zip_code"
    end
  end

  # helper funct to create a temporary file for testing
  defp create_temp_file(content) do
    path = Path.join(System.tmp_dir!(), "test_upload_#{:rand.uniform(100_000)}")
    File.write!(path, content)
    on_exit(fn -> File.rm(path) end)
    path
  end
end
