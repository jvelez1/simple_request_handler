defmodule Servy.Handler do
  @moduledoc """
    Handles HTTP requests.
  """

  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv
  import Servy.Plugins
  import Servy.Parser

  @doc """
    Transforms the request into a response
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  # def route(conv) do
  #   route(conv, conv.method ,conv.path)
  # end

  def route(%Conv{method: "GET", path: "/animals"} = conv) do
    %{ conv | body: "Lion, Dog, Cat", status: 200 }
  end

  def route(%Conv{method: "GET", path: "/cars"} = conv) do
    %{ conv | body: "Ford, Mazda, Chevrolet", status: 200 }
  end

  def route(%Conv{method: "GET", path: "/cars" <> id} = conv) do
    %{ conv | body: "card #{id}", status: 200 }
  end

  def route(%Conv{method: "POST", path: "/animals"} = conv) do
    %{ conv | body: "Animal Created! animal: #{conv.params["name"]} type: #{conv.params["type"]}", status: 201 }
  end

  # def route(%Conv{method: "GET", path: "/about"} = conv) do
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

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
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

  def format_response(%Conv{} = conv) do
    IO.inspect("""
      HTTP/1.1 #{Conv.full_status(conv)}
      Content-Type: text/html
      Content-Length #{String.length(conv.body)}

      #{conv.body}
    """)
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

post_animal = """
POST /animals HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Lenght: 21

name=Bear&type=Brown
"""

Servy.Handler.handle(request)
# Servy.Handler.handle(car)
# Servy.Handler.handle(car_id)
# Servy.Handler.handle(requesti)
# Servy.Handler.handle(things)
Servy.Handler.handle(about)
Servy.Handler.handle(post_animal)
