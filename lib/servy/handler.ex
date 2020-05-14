defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       body: "",
       status: nil
    }
  end

  def log(conv), do: IO.inspect conv

  def route(conv) do
    route(conv, conv.method ,conv.path)
  end

  def route(conv, "GET", "/animals") do
    %{ conv | body: "Lion, Dog, Cat", status: 200 }
  end

  def route(conv, "GET", "/cars") do
    %{ conv | body: "Ford, Mazda, Chevrolet", status: 200 }
  end

  def route(conv, "GET", "/cars/" <> id) do
    %{ conv | body: "card #{id}", status: 200 }
  end

  def route(conv, _method, path) do
    %{ conv | body: "Not valid for #{path}", status: 404 }
  end

  def format_response(conv) do
    """
      HTTP/1.1 "#{conv.status}" "#{status_reason(conv.status)}"
      Content-Type: text/html
      Content-Length #{String.length(conv.body)}

      #{conv.body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK!",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /animals HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""

car = """
GET /cars HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""

car_id = """
GET /cars/1 HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""

requesti = """
GET /invalid HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""


Servy.Handler.handle(request)
Servy.Handler.handle(car)
Servy.Handler.handle(car_id)
Servy.Handler.handle(requesti)
