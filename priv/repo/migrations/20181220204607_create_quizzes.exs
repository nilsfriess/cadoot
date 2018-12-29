defmodule Sindubio.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :title, :string
      add :description, :string
      add :pin, :integer

      timestamps()
    end

    create unique_index(:quizzes, [:pin])
  end
end
