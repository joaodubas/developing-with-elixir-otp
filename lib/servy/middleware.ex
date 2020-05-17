defmodule Servy.Middleware do
  require Logger

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

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("{path: #{path}, message: is on the loose}")
    conv
  end

  def track(conv), do: conv

  def emojify(%{status: 200, body: body} = conv) do
    %{conv | body: "😷 #{body} 😍"}
  end

  def emojify(conv), do: conv
end
