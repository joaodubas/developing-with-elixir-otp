defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> log()
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

  def log(conv), do: IO.inspect conv

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | body: "Teddy, Smokey, Paddington"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv[:body])}

    #{conv[:body]}
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

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response
