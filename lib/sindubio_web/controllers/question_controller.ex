defmodule SindubioWeb.QuestionController do
  use SindubioWeb, :controller

  alias Sindubio.Quizzes
  alias Sindubio.Quizzes.Question

  def index(conn, _params) do
    questions = Quizzes.list_questions()
    render(conn, "index.html", questions: questions)
  end

  def new(conn, _params) do
    changeset = Quizzes.change_question(%Question{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"question" => question_params}) do
    case Quizzes.create_question(question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: Routes.quiz_path(conn, :edit, question.quiz))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Quizzes.get_question(id)
    render(conn, "show.html", question: question)
  end

  def edit(conn, %{"id" => id}) do
    question = Quizzes.get_question(id)
    changeset = Quizzes.change_question(question)
    render(conn, "edit.html", question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Quizzes.get_question(id)

    case Quizzes.update_question(question, question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: Routes.quiz_path(conn, :edit, question.quiz.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Quizzes.get_question(id)
    {:ok, _question} = Quizzes.delete_question(question)

    IO.puts("delete")

    conn
    # |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: Routes.quiz_path(conn, :edit, question.quiz))
  end
end
