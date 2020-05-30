defmodule Servy.Controllers.CarController do
  alias Servy.Structs.Car

  def index(conv) do
    cars =
      Car.list
      |> Enum.sort(&Car.order_by_name/2) # Equal to: Enum.map(&Car.order_by_name(&1, &2)) OR Equals to: Enum.map(fn(car1, car2) -> car1.brand <= car2.brand end)
      |> Enum.map(&li_car/1) # Equal to: Enum.map(&li_car(&1)) OR Equals to: Enum.map(fn(car) -> "<li>#{car.brand} #{car.type}</li>" end)
      |> Enum.join

    %{ conv | body: "<ul>#{cars}</ul>", status: 200 }
  end

  def show(conv, %{"id" => id} = _params) do
    car = Car.find(id)
    %{ conv | body: "<h1> Car #{car.id}: #{car.brand} #{car.type} </h1>", status: 200 }
  end

  def create(conv, %{"brand" => brand, "type" => type} = params) do
    %{ conv | body: "Card Created! Brand: #{brand} type: #{type}", status: 201 }
  end

  defp li_car(car) do
    "<li>#{car.brand} #{car.type}</li>"
  end
end
