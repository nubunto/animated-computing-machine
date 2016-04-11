defmodule Monitor.ApplicationView do
  use Monitor.Web, :view

  def render("index.json", %{applications: applications}) do
    %{data: render_many(applications, Monitor.ApplicationView, "application.json")}
  end

  def render("show.json", %{application: application}) do
    %{data: render_one(application, Monitor.ApplicationView, "application.json")}
  end

  def render("application.json", %{application: application}) do
    %{id: application.id}
  end
end
