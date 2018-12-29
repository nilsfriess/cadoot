defmodule SindubioWeb.QuizController do
  use SindubioWeb, :controller

  alias Sindubio.Quizzes
  alias Sindubio.Quizzes.Quiz

  def index(conn, _params) do
    quizzes = Quizzes.list_quizzes()
    render(conn, "index.html", quizzes: quizzes)
  end

  def new(conn, _params) do
    changeset = Quizzes.change_quiz(%Quiz{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"quiz" => quiz_params}) do
    case Quizzes.create_quiz(quiz_params) do
      {:ok, quiz} ->
        conn
        |> redirect(to: Routes.quiz_path(conn, :show, quiz))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)
    render(conn, "show.html", quiz: quiz)
  end

  alias Sindubio.Quizzes.Question

  def edit(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)
    changeset = Quizzes.change_quiz(quiz)

    question_changeset = Quizzes.change_question(%Quizzes.Question{})

    question_changesets =
      quiz.questions
      |> Enum.map(fn q -> Quizzes.change_question(q) end)

    render(conn, "edit.html",
      quiz: quiz,
      changeset: changeset,
      question_changeset: question_changeset,
      question_changesets: question_changesets
    )
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Quizzes.get_quiz!(id)

    case Quizzes.update_quiz(quiz, quiz_params) do
      {:ok, quiz} ->
        conn
        |> put_flash(:info, "Quiz updated successfully.")
        |> redirect(to: Routes.quiz_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", quiz: quiz, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)
    {:ok, _quiz} = Quizzes.delete_quiz(quiz)

    conn
    |> put_flash(:info, "Quiz deleted successfully.")
    |> redirect(to: Routes.quiz_path(conn, :index))
  end

  def start_quiz(conn, %{"pin_input" => pin}) do
    case Quizzes.get_quiz_by_pin(pin) do
      {:ok, quiz} ->
        IO.inspect(quiz)
        render(conn, "start.html", quiz: quiz)

      {:err, _} ->
        conn
        |> put_flash(:error, "Quiz not found")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def host_info(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)

    rand_pin = Enum.random(100_000..999_999)
    Quizzes.update_quiz(quiz, %{pin: rand_pin})

    render(conn, "info.html", quiz: quiz, pin: rand_pin)
  end

  def host(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)

    SindubioWeb.Endpoint.broadcast(
      "quiz:" <> Integer.to_string(quiz.pin),
      "before_start",
      %{pin: quiz.pin, time: 5, msg: "Quiz about to start"}
    )

    task = Task.async(fn -> host_start(conn, %{quiz: quiz}) end)

    render(conn, "host.html", quiz: quiz)
  end

  def host_start(conn, %{quiz: quiz}) do
    :timer.sleep(5000)

    question_count = quiz.questions |> Enum.count()

    SindubioWeb.Endpoint.broadcast("quiz:" <> Integer.to_string(quiz.pin), "start", %{
      msg: "Quiz starts!",
      questionCount: question_count
    })

    question =
      quiz.questions
      |> Enum.at(0)

    SindubioWeb.Endpoint.broadcast!("quiz:" <> Integer.to_string(quiz.pin), "next_question", %{
      answer1: question.answer1,
      answer2: question.answer2,
      answer3: question.answer3,
      answer4: question.answer4,
      answer1correct: question.answer1_correct,
      answer2correct: question.answer2_correct,
      answer3correct: question.answer3_correct,
      answer4correct: question.answer4_correct,
      quizPin: quiz.pin,
      questionNumber: 0,
      question: question.title,
      code: question.code
    })
  end
end
