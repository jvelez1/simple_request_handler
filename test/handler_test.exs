defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler

  test "GET /animals" do
    request = """
    GET /animals HTTP/1.1\r
    Host: example.com\r
    User-Agent: Browser/1.0\r
    Accept: */*\r
    \r
    """
    response = """
    HTTP/1.1 200 OK!\r
    Content-Type: text/html\r
    Content-Length: 14\r
    \r
    Lion, Dog, Cat
    """

    assert response == handle(request)
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK!\r
    Content-Type: text/html\r
    Content-Length: 102\r
    \r
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 22\r
    \r
    Not valid for /bigfoot
    """
  end

  test "GET /cars" do
    request = """
    GET /cars HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK!\r
    Content-Type: text/html\r
    Content-Length: 413\r
    \r
    <h1>Cars</h1>

    <ul>
    <li>Chevrolet-Corsa-Black</li>
    <li>Dodge-Range-green</li>
    <li>Ford-Fiesta-Blue</li>
    <li>Honda-Polar-green</li>
    <li>Mazda-3-Black</li>
    <li>Nissan-Grizzly-Black</li>
    <li>Renault-Polar-Black</li>
    <li>SEAT-Grizzly-Black</li>
    <li>Suzuki-Panda-Black</li>
    <li>Toyota-CC-green</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /cars/1" do
    request = """
    GET /cars/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK!\r
    Content-Type: text/html\r
    Content-Length: 62\r
    \r
    <h1>Show Car</h1>
    <p>
      Ford color: <strong>Blue</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /cars" do
    request = """
    POST /cars HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    brand=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 38\r
    \r
    Card Created! Brand: Baloo type: Brown
    """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
