defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")
    %{method: method, path: path, body: ""}
  end

  def route(_conv) do
    # TODO: create a new map that also has the response body
    %{method: "GET", path: "/wildthinks", body: "Bears, Lions, Tigers"}
  end

  def format_response(_conv) do
    # TODO: use values in the map to create a HTTP response string
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response
