defmodule Sindubio.Repo.Migrations.UpdateQuestionsTable do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :code, :text
    end
  end
end
