defmodule Servy.Fetcher do
  #THIS MODULE IS INVALID USE Elixir Task.

  def asycn(fun) do
    parent = self() # Current Process

    spawn(fn -> send( parent, {:result, fun.()}) end)
  end

  def get_result do
    receive do {:result, result} -> result end
  end
end
