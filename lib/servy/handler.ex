defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
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

  def rewrite_path(%{path: "/animals"} = conv) do
    %{ conv | path: "/animals" }
  end

  def rewrite_path(conv), do: conv

  def track(%{status: 404, path: path} = conv) do
    IO.puts "WARNING! #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  # def route(conv) do
  #   route(conv, conv.method ,conv.path)
  # end

  def route(%{method: "GET", path: "/animals"} = conv) do
    %{ conv | body: "Lion, Dog, Cat", status: 200 }
  end

  def route(%{method: "GET", path: "/cars"} = conv) do
    %{ conv | body: "Ford, Mazda, Chevrolet", status: 200 }
  end

  def route(%{method: "GET", path: "/cars" <> id} = conv) do
    %{ conv | body: "card #{id}", status: 200 }
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file_path =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #     case File.read(file_path) do
  #     {:ok, content} ->
  #       %{ conv | status: 200, body: content }
  #     {:error, :enoent} ->
  #       %{ conv | status: 404, body: "File not found" }
  #     {:error, reason} ->
  #       %{ conv | status: 500, body: "Internal Server error: #{reason}"}
  #   end
  # end

  def route(%{method: "GET", path: "/about"} = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, body: "Internal Server error: #{reason}"}
  end

  def route(%{path: path} = conv) do
    %{ conv | body: "Not valid for #{path}", status: 404 }
  end

  def format_response(conv) do
    IO.inspect("""
      HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
      Content-Type: text/html
      Content-Length #{String.length(conv.body)}

      #{conv.body}
    """)
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

# car = """
# GET /cars HTTP/1.1
# Host: example.com
# User-Agent: Browser/1.0
# Accept: */*
# """

# car_id = """
# GET /cars/1 HTTP/1.1
# Host: example.com
# User-Agent: Browser/1.0
# Accept: */*
# """

# requesti = """
# GET /invalid HTTP/1.1
# Host: example.com
# User-Agent: Browser/1.0
# Accept: */*
# """

# things = """
# GET /things HTTP/1.1
# Host: example.com
# User-Agent: Browser/1.0
# Accept: */*
# """

about = """
GET /about HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
"""

Servy.Handler.handle(request)
# Servy.Handler.handle(car)
# Servy.Handler.handle(car_id)
# Servy.Handler.handle(requesti)
# Servy.Handler.handle(things)
Servy.Handler.handle(about)
