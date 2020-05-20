defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [request_line, message_body] = String.split(request, "\n\n")
    [general_header | headers_string] = String.split(request_line, "\n")
    [method, path, _protocol] = String.split(general_header, " ")
    headers = parse_headers(headers_string, %{})
    params = parse_body(headers["Content-Type"], message_body)
    %Conv{method: method, path: path, params: params, headers: headers, body: "", status: nil}
  end

  def parse_headers([head | tail], headers) do
    parse_headers(tail, apply(Map, :put, [headers | String.split(head, ": ")]))
  end

  def parse_headers([], headers), do: headers

  def parse_body("application/x-www-form-urlencoded", message) do
    message
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_body(_, _), do: %{}
end
