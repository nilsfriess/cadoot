defmodule SindubioWeb.QuizChannel do
  use Phoenix.Channel
  alias SindubioWeb.Presence

  def join("quiz:" <> _channel_pin, _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in(
        "next_question_host",
        %{"questionNumber" => question_number, "quizPin" => quiz_pin},
        socket
      ) do
    {:ok, quiz} = Sindubio.Quizzes.get_quiz_by_pin(quiz_pin)

    question =
      quiz.questions
      |> Enum.at(question_number)

    broadcast(socket, "next_question", %{
      answer1: question.answer1,
      answer2: question.answer2,
      answer3: question.answer3,
      answer4: question.answer4,
      answer1correct: question.answer1_correct,
      answer2correct: question.answer2_correct,
      answer3correct: question.answer3_correct,
      answer4correct: question.answer4_correct,
      questionNumber: question_number,
      quizPin: quiz_pin,
      question: question.title,
      code: question.code
    })

    {:noreply, socket}
  end

  def handle_in("show_solution", params, socket) do
    broadcast(socket, "show_solution", params)
    {:noreply, socket}
  end

  def handle_in("request:uuid", _params, socket) do
    uuid = Ecto.UUID.generate() |> binary_part(1, 16)
    {:ok, _} = Presence.track(socket, :users, %{})

    broadcast!(socket, "presence_state", Presence.list(socket))

    {:reply, {:ok, %{uuid: uuid}}, socket}
  end

  def handle_in("answers:" <> _uuid, %{"answers" => _answers}, socket) do
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:noreply, socket}
  end
end
