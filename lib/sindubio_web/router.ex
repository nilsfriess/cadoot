defmodule SindubioWeb.Router do
  use SindubioWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SindubioWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    get("/quiz", QuizController, :start_quiz)

    get("/info/:id", QuizController, :host_info)
    get("/host/:id", QuizController, :host)

    resources("/quizzes", QuizController)
    resources("/question", QuestionController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SindubioWeb do
  #   pipe_through :api
  # end
end
