defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")
    parsed_headers = parse_headers(header_lines, %{})
    params_string = parse_params(parsed_headers["Content-type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params_string,
      headers: parsed_headers
    }
  end

  #just handled this kind of content type
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    IO.inspect "PARSE HEADERS"
    IO.inspect head
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
