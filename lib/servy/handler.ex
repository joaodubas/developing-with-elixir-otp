defmodule Servy.Handler do
  require Logger

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

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")
    %{method: method, path: path, body: "", status: nil}
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def log(conv) do
    Logger.debug("{method: #{conv.method}, path: #{conv.path}}")
    conv
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | body: "Teddy, Smokey, Paddington", status: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | body: "Bear #{id}", status: 200}
  end

  def route(%{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | body: "Delete bear #{id} is forbidden!", status: 403}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file =
      "../../priv/pages"
      |> Path.expand(__DIR__)
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        %{conv | body: content, status: 200}
      {:error, :enoent} ->
        %{conv | body: "File not found!", status: 404}
      {:error, reason} ->
        %{conv | body: "File error: #{reason}", status: 500}
    end
  end

  def route(%{method: _, path: path} = conv) do
    %{conv | body: "No #{path} in here!", status: 404}
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("{path: #{path}, message: is on the loose}")
    conv
  end

  def track(conv), do: conv

  def emojify(%{status: 200, body: body} = conv) do
    %{conv | body: "😷 #{body} 😍"}
  end

  def emojify(conv), do: conv

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.body)}

    #{conv.body}
    """
  end

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
