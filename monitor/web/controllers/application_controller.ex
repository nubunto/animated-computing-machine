defmodule Monitor.ApplicationController do
  use Monitor.Web, :controller

  alias Monitor.Application

  plug :scrub_params, "application" when action in [:create, :update]

  def index(conn, _params) do
    applications = Repo.all(Application)
    render(conn, "index.json", applications: applications)
  end

  def create(conn, %{"application" => application_params}) do
    changeset = Application.changeset(%Application{}, application_params)

    case Repo.insert(changeset) do
      {:ok, application} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", application_path(conn, :show, application))
        |> render("show.json", application: application)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Monitor.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    render(conn, "show.json", application: application)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    application = Repo.get!(Application, id)
    changeset = Application.changeset(application, application_params)

    case Repo.update(changeset) do
      {:ok, application} ->
        render(conn, "show.json", application: application)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Monitor.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(application)

    send_resp(conn, :no_content, "")
  end
end
