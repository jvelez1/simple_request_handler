defmodule Servy.Handler do
  @moduledoc """
    Handles HTTP requests.
  """
  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv
  alias Servy.Controllers.CarController
  alias Servy.Controllers.Api
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

  def route(%Conv{method: "GET", path: "/animals"} = conv) do
    %{ conv | body: "Lion, Dog, Cat", status: 200 }
  end

  def route(%Conv{method: "GET", path: "/cars"} = conv) do
    CarController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/cars"} = conv) do
    Api.CarController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/cars/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    CarController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/cars"} = conv) do
    CarController.create(conv, conv.params)
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

  def route(%{path: path} = conv) do
    %{ conv | body: "Not valid for #{path}", status: 404 }
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

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.response_content_type}\r
    Content-Length: #{String.length(conv.body)}\r
    \r
    #{conv.body}
    """
  end
end
