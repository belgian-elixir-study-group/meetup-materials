defmodule Html do

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, Html)} = start_buffer []
      unquote(block)
      result = render var!(buffer, Html)
      :ok = stop_buffer var!(buffer, Html)
      result
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)

  def stop_buffer(buff), do: Agent.stop(buff)

  def put_buffer(buff, content), do: Agent.update(buff, &[ content | &1 ]  )

  def render(buff), do: Agent.get(buff, &(&1)) |> Enum.reverse |> Enum.join("")

  defmacro tag(name, attrs \\ []) do
    {inner, attrs} = Dict.pop(attrs, :do)
    quote do: tag(unquote(name), unquote(attrs), do: unquote(inner))
  end


  defmacro tag(name, attrs, do: inner) do
    quote do

      put_buffer var!(buffer, Html), open_tag(unquote_splicing([name, attrs]))
      unquote inner
      put_buffer var!(buffer, Html), "</#{unquote(name)}>"
    end
  end

  def open_tag(name, []), do: "<#{name}>"

  def open_tag(name, attrs) do
    attr_html = for {key, val} <- attrs, into: "", do: " #{key}=\"#{val}\""
    "<#{name}#{attr_html}>"
  end

  defmacro text(string) do
    quote do
      put_buffer var!(buffer, Html), to_string(unquote(string))
    end
  end
end


defmodule Template do

  import Html

  def render do
    markup do
      tag "div", id: "main" do
        tag "h1", class: "title" do
          text "Welcome"
        end
        tag "div", class: "row" do
          tag "div" do
            tag "p",  do: text "Hello!"
          end
        end
      end
      tag "table"  do
        tag "tr"  do
          for i <- 0..5 do
            tag "td", do: text("Cell #{i}")
          end
        end
      end
      tag "div" do
        text "Some nested content"
      end
    end
  end

end

IO.puts Template.render
