defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "Parses a list of header fields into a map" do
    header_lines = ["A: 1", "B: 2"]
    parsed = Parser.parse_headers(header_lines, %{})
    assert parsed == %{ "A" => "1", "B" => "2" }
  end
end
