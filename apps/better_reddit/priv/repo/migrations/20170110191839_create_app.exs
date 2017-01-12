defmodule BetterReddit.Repo.Migrations.CreateApp do
  use Ecto.Migration

  def change do
    create table(:apps) do

      timestamps()
    end

  end
end
