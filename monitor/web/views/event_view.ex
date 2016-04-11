defmodule Monitor.EventView do
  use Monitor.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, Monitor.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, Monitor.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      origin: event.origin,
      data: event.data}
  end
end
