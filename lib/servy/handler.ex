defmodule Servy.Handler do
  @moduledoc "Servy HTTP handler requests/response."

  alias Servy.Conv

  import Servy.Middleware, only: [emojify: 1, log: 1, rewrite_path: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.Static, only: [handle_static: 2]

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> emojify()
    |> format_response()
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | body: "Teddy, Smokey, Paddington", status: 200}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %{conv | body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}", status: 201}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | body: "Bear #{id}", status: 200}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | body: "Delete bear #{id} is forbidden!", status: 403}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    handle_static("about.html", conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    handle_static("#{page}.html", conv)
  end

  def route(%Conv{method: _, path: path} = conv) do
    %{conv | body: "No #{path} in here!", status: 404}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{Conv.body_size(conv)}

    #{conv.body}
    """
  end
end

# ---

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /bears/Teddy HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /bears?id=Grumpy HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
DELETE /bears/Teddy HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
GET /pages/any-other-page HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.1
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

# ---

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)
IO.puts response
