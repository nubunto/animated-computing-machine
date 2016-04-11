defmodule Monitor.Router do
  use Monitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Monitor do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "api/", Monitor do
    pipe_through :api
    resources "/events", EventController, except: [:new, :edit]
    resources "/applications", ApplicationController, except: [:new, :edit]
  end
end
