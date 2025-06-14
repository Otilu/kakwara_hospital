defmodule KakwaraHospitalWeb.Router do
  use KakwaraHospitalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KakwaraHospitalWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KakwaraHospitalWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/main", PageController, :main
    get "/about", PageController, :about
    get "/contact", PageController, :contact
    get "/blog", PageController, :blog
    get "/dashboard", PageController, :dashboard
    get "/services", PageController, :services
    get "/settings", PageController, :settings
    get "/profile", PageController, :profile
    get "/login", PageController, :login
    get "/signup", PageController, :signup
    get "/help", PageController, :help
    get "/forgot_password", PageController, :forgot_password
   get "/team", PageController, :team
   get "/logout", PageController, :logout
   get "/search", PageController, :search
  end

  # Other scopes may use custom stacks.
  # scope "/api", KakwaraHospitalWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:kakwara_hospital, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KakwaraHospitalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
