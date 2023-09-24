defmodule RedirexWeb.Router do
  use RedirexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RedirexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RedirexWeb do
    pipe_through :browser

    live "/", LinkLive.Index, :new
    live "/links/:hash", LinkLive.Show, :show
    live "/stats", LinkLive.Index, :index
    # live "/links/:hash/edit", LinkLive.Index, :edit

    # live "/links/:hash/show/edit", LinkLive.Show, :edit

    # live "/:hash", LinkLive.Index, :redirect

    get "/download", LinkController, :csv
    get "/:hash", LinkController, :redirect
  end

  # Other scopes may use custom stacks.
  # scope "/api", RedirexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:redirex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RedirexWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
