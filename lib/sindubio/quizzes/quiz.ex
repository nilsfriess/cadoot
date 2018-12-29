defmodule Sindubio.Quizzes.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quizzes" do
    field(:description, :string)
    field(:pin, :integer)
    field(:title, :string)

    has_many(:questions, Sindubio.Quizzes.Question)

    timestamps()
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title, :description, :pin])
    |> validate_required([:title, :description, :pin])
    |> unique_constraint(:pin)
  end
end
