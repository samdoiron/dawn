defmodule BetterReddit.AppControllerTest do
  use BetterReddit.ConnCase

  alias BetterReddit.App
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, app_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing apps"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, app_path(conn, :new)
    assert html_response(conn, 200) =~ "New app"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, app_path(conn, :create), app: @valid_attrs
    assert redirected_to(conn) == app_path(conn, :index)
    assert Repo.get_by(App, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, app_path(conn, :create), app: @invalid_attrs
    assert html_response(conn, 200) =~ "New app"
  end

  test "shows chosen resource", %{conn: conn} do
    app = Repo.insert! %App{}
    conn = get conn, app_path(conn, :show, app)
    assert html_response(conn, 200) =~ "Show app"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, app_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    app = Repo.insert! %App{}
    conn = get conn, app_path(conn, :edit, app)
    assert html_response(conn, 200) =~ "Edit app"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    app = Repo.insert! %App{}
    conn = put conn, app_path(conn, :update, app), app: @valid_attrs
    assert redirected_to(conn) == app_path(conn, :show, app)
    assert Repo.get_by(App, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    app = Repo.insert! %App{}
    conn = put conn, app_path(conn, :update, app), app: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit app"
  end

  test "deletes chosen resource", %{conn: conn} do
    app = Repo.insert! %App{}
    conn = delete conn, app_path(conn, :delete, app)
    assert redirected_to(conn) == app_path(conn, :index)
    refute Repo.get(App, app.id)
  end
end
