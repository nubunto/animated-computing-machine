defmodule Monitor.ApplicationControllerTest do
  use Monitor.ConnCase

  alias Monitor.Application
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, application_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    application = Repo.insert! %Application{}
    conn = get conn, application_path(conn, :show, application)
    assert json_response(conn, 200)["data"] == %{"id" => application.id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, application_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, application_path(conn, :create), application: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Application, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, application_path(conn, :create), application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    application = Repo.insert! %Application{}
    conn = put conn, application_path(conn, :update, application), application: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Application, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    application = Repo.insert! %Application{}
    conn = put conn, application_path(conn, :update, application), application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    application = Repo.insert! %Application{}
    conn = delete conn, application_path(conn, :delete, application)
    assert response(conn, 204)
    refute Repo.get(Application, application.id)
  end
end
