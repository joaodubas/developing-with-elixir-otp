defmodule Servy.Static do

  @pages_path ["..", "..", "priv", "pages"] |> Path.join() |> Path.expand(__DIR__)

  def handle_static(filename, conv) do
    @pages_path
    |> Path.join(filename)
    |> File.read()
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{conv | body: content, status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | body: "File not found!", status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | body: "File error: #{reason}", status: 500}
  end
end
