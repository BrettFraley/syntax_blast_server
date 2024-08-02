defmodule SyntaxBlastServerWeb.Router do
  use SyntaxBlastServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SyntaxBlastServerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SyntaxBlastServerWeb do
    pipe_through :browser

    get "/", PageController, :home

    # CRUD Admin Routes for Levels table
    live "/levels", LevelLive.Index, :index
    live "/levels/new", LevelLive.Index, :new
    live "/levels/:id/edit", LevelLive.Index, :edit
    live "/levels/:id", LevelLive.Show, :show
    live "/levels/:id/show/edit", LevelLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SyntaxBlastServerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:syntax_blast_server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SyntaxBlastServerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
