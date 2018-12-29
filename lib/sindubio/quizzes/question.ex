defmodule Sindubio.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field(:title, :string)
    field(:code, :string, default: "")

    field(:answer1, :string)
    field(:answer2, :string)
    field(:answer3, :string)
    field(:answer4, :string)

    field(:answer1_correct, :boolean, default: false)
    field(:answer2_correct, :boolean, default: false)
    field(:answer3_correct, :boolean, default: false)
    field(:answer4_correct, :boolean, default: false)

    belongs_to(:quiz, Sindubio.Quizzes.Quiz)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [
      :title,
      :code,
      :quiz_id,
      :answer1,
      :answer2,
      :answer3,
      :answer4,
      :answer1_correct,
      :answer2_correct,
      :answer3_correct,
      :answer4_correct
    ])
    |> validate_required([
      :title,
      :quiz_id,
      :answer1,
      :answer2,
      :answer3,
      :answer4,
      :answer1_correct,
      :answer2_correct,
      :answer3_correct,
      :answer4_correct
    ])
  end
end
