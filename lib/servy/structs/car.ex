defmodule Servy.Structs.Car do
  alias __MODULE__

  defstruct(
    id: nil,
    brand: "",
    type: "",
    color: "Black"
  )

  def list do
    [
      %Car{id: 1, brand: "Ford", type: "Fiesta", color: "Blue"},
      %Car{id: 2, brand: "Chevrolet", type: "Corsa"},
      %Car{id: 3, brand: "Mazda", type: "3"},
      %Car{id: 4, brand: "Dodge", type: "Range", color: "green"},
      %Car{id: 5, brand: "Renault", type: "Polar"},
      %Car{id: 6, brand: "Nissan", type: "Grizzly"},
      %Car{id: 7, brand: "Toyota", type: "CC", color: "green"},
      %Car{id: 8, brand: "Suzuki", type: "Panda"},
      %Car{id: 9, brand: "Honda", type: "Polar", color: "green"},
      %Car{id: 10, brand: "SEAT", type: "Grizzly"}
    ]
  end
end
