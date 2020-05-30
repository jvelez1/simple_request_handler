defmodule Servy.Controllers.CarController do
  alias Servy.Structs.Car

  def index(conv) do
    IO.inspect(Car.list)
    #TODDO
    %{ conv | body: "Ford, Mazda, Chevrolet", status: 200 }
  end

  def show(conv, %{"id" => id} = _params) do
    %{ conv | body: "card #{id} Ford", status: 200 }
  end

  def create(conv, %{"brand" => brand, "type" => type} = params) do
    %{ conv | body: "Card Created! Brand: #{brand} type: #{type}", status: 201 }
  end
end
