defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, body: "" }
  end

  def route(conv) do
    %{ conv | body: "One, two, three" }
  end

  def format_response(conv) do
    """
      HTTP/1.1 200 ok
      Content-Type: text/html
      Content-Length #{String.length(conv.body)}

      #{conv.body}
    """
  end
end

request = """
GET /items HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""
Servy.Handler.handle(request)
