defmodule Servy.Controllers.CarController do
  @templates_cars_path Path.expand("../../../templates/cars", __DIR__)

  alias Servy.Structs.Car

  def index(conv) do
    cars =
      Car.list
      |> Enum.sort(&Car.order_by_name/2) # Equal to: Enum.map(&Car.order_by_name(&1, &2)) OR Equals to: Enum.map(fn(car1, car2) -> car1.brand <= car2.brand end)

    render(conv, "index.eex", cars: cars)
  end

  def show(conv, %{"id" => id} = _params) do
    car = Car.find(id)

    render(conv, "show.eex", car: car)
  end

  def create(conv, %{"brand" => brand, "type" => type} = params) do
    %{ conv | body: "Card Created! Brand: #{brand} type: #{type}", status: 201 }
  end

  defp render(conv, template, args \\ [] ) do
    content =
      @templates_cars_path
      |> Path.join(template)
      |> EEx.eval_file(args)

     %{ conv | body: content, status: 200 }
  end
end
