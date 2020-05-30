defmodule Servy.Plugins do
  alias Servy.Conv

  def rewrite_path(%Conv{path: "/animals"} = conv) do
    %{ conv | path: "/animals" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      IO.puts "WARNING! #{path} is on the loose!"
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env != :test do
      IO.inspect(conv)
    end
    conv
  end
end
