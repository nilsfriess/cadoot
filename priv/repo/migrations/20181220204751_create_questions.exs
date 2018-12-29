defmodule Sindubio.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :answer1, :string
      add :answer2, :string
      add :answer3, :string
      add :answer4, :string

      add :answer1_correct, :boolean
      add :answer2_correct, :boolean
      add :answer3_correct, :boolean
      add :answer4_correct, :boolean
      
      add :quiz_id, references(:quizzes, on_delete: :nothing)

      timestamps()
    end

    create index(:questions, [:quiz_id])
  end
end
