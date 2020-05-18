defmodule Servy.Conv do
  defstruct [
    method: "",
    path: "",
    params: %{},
    body: "",
    status: 0
  ]

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  def body_size(%{body: body}), do: byte_size(body)

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
