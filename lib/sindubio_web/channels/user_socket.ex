defmodule SindubioWeb.UserSocket do
  use Phoenix.Socket

  channel("quiz:*", SindubioWeb.QuizChannel)

  def connect(params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, params["user_id"])}
  end

  def id(_socket), do: nil
end
