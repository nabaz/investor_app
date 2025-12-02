defmodule InvestorAppWeb.PageController do
  use InvestorAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
