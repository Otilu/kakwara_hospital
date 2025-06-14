defmodule KakwaraHospitalWeb.PageController do
  use KakwaraHospitalWeb, :controller

  # This module defines the PageController for handling requests to the main page.
  # It renders the main page without a layout.
  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
  def main(conn, _params) do
    render(conn, :main, layout: false)
  end
  # This function handles requests to the "about" page.
  def about(conn, _params) do
    render(conn, :about, layout: false)
  end
  # This function handles requests to the "contact" page.
  def contact(conn, _params) do
    render(conn, :contact, layout: false)
  end
  # This function handles requests to the "privacy" page.
  def blog(conn, _params) do
    render(conn, :blog, layout: false)
  end
  # This function handles requests to the "terms" page.
  def dashboard(conn, _params) do
    render(conn, :dashboard, layout: false)
  end
  #
  def services(conn, _params) do
    render(conn, :services, layout: false)
  end
  #
  def settings(conn, _params) do
    render(conn, :settings, layout: false)
  end
  #
  def profile(conn, _params) do
    render(conn, :profile, layout: false)
  end
  # This function handles requests to the "login" page.
  def login(conn, _params) do
    render(conn, :login, layout: false)
  end
  # This function handles requests to the "register" page.
  def signup(conn, _params) do
    render(conn, :signup, layout: false)
  end
  # This function handles requests to the "forgot password" page.
  def help(conn, _params) do
    render(conn, :help, layout: false)
  end
  # This function handles requests to the "reset password" page.
  def forgot_password(conn, _params) do
    render(conn, :forgot_password, layout: false)
  end
  # This function handles requests to the "reset password" page.
  def team(conn, _params) do
    render(conn, :team, layout: false)
  end
  # This function handles requests to the "home" page.
  def logout(conn, _params) do
    render(conn, :home, layout: false)
  end
  def search(conn, _params) do
    render(conn, :search, layout: false)
  end
end
# This module defines the PageController for handling requests to various pages of the application.
# It includes functions to render the main page, about page, contact page, blog, dashboard,
