defmodule SindubioWeb.ViewHelpers do
  import Phoenix.HTML

  def active_class(conn, path) do
    current_path = Path.join(["/" | conn.path_info])

    if path == current_path do
      "active"
    else
      nil
    end
  end

  def active_link(conn, text, path, opts) do
    class =
      [opts[:class], active_class(conn, path)]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    opts =
      opts
      |> Keyword.put(:class, class)
      |> Keyword.put(:to, path)

    Phoenix.HTML.link(text, opts)
  end
end
