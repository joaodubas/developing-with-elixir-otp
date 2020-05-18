defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [request_line, message_body] = String.split(request, "\n\n")
    [general_header | _headers_string] = String.split(request_line, "\n")
    [method, path, _protocol] = String.split(general_header, " ")
    params = parse_body(message_body)
    %Conv{method: method, path: path, params: params, body: "", status: nil}
  end

  def parse_body(message) do
    message
    |> String.trim()
    |> URI.decode_query()
  end
end
