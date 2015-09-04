defmodule Swotter.Router do
  use Swotter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug HelloPhoenix.Plugs.InitUser
  end

  pipeline :api do
    plug :fetch_session
    plug HelloPhoenix.Plugs.InitUser
    plug :accepts, ["json"]
  end

  scope "/", Swotter do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users",  UserController

    get "/login",  SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    get "/signup",  RegistrationController, :new
    post "/signup", RegistrationController, :create

    get "/private_pages",  PrivatePageController, :index

  end

  # Other scopes may use custom stacks.


  scope "/api", Swotter do
    pipe_through :api

    get "/auth_ticket",  AuthTicketController, :new

  end

end
