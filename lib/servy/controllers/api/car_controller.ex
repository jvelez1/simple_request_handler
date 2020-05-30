defmodule Servy.Controllers.Api.CarController do
  alias Servy.Structs.Car


  def index(conv) do
    json =
      Car.list
      |> Poison.encode!

      %{ conv | status: 200, response_content_type: "application/json", body: json }
  end
end
