defmodule Servy.Middleware do
  alias Servy.Conv

  require Logger

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    Logger.debug("{method: #{conv.method}, path: #{conv.path}}")
    conv
  end

  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warn("{path: #{path}, message: is on the loose}")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def emojify(%Conv{status: 200, body: body} = conv) do
    %{conv | body: "😷 #{body} 😍"}
  end

  def emojify(%Conv{} = conv), do: conv
end
