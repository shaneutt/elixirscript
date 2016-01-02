defmodule ElixirScript.Kernel do
  import Kernel, only: [defmodule: 2, def: 1, def: 2, defp: 2,
  defmacro: 1, defmacro: 2, defmacrop: 2, ||: 2, !: 1, ++: 2, in: 2, &&: 2, ===: 2]

  defmacro if(condition, clauses) do
    build_if(condition, clauses)
  end

  defp build_if(condition, do: do_clause) do
    build_if(condition, do: do_clause, else: nil)
  end

  defp build_if(condition, do: do_clause, else: else_clause) do
    quote do
      case unquote(condition) do
        x when x in [false, nil] ->
          unquote(else_clause)
        _ ->
          unquote(do_clause)
      end
    end
  end

  defmacro unless(condition, clauses) do
    build_unless(condition, clauses)
  end

  defp build_unless(condition, do: do_clause) do
    build_unless(condition, do: do_clause, else: nil)
  end

  defp build_unless(condition, do: do_clause, else: else_clause) do
    quote do
      if(unquote(condition), do: unquote(else_clause), else: unquote(do_clause))
    end
  end

  def abs(number) do
    Math.abs(number)
  end

  def apply(fun, args) do
    Elixir.Core.Functions.apply(fun, args)
  end

  def apply(module, fun, args) do
    fun = if Elixir.Core.is_atom(fun), do: Atom.to_string(fun), else: fun
    Elixir.Core.Functions.apply(module, fun, args)
  end

  def binary_part(binary, start, len) do
    binary.substring(start, len)
  end

  def hd(list) do
    list[0]
  end

  def tl(list) do
    list.slice(1)
  end

  def get_type(term) do
    Elixir.Core.Functions.get_type(term)
  end

  def is_instance_of(term, type) do
    Elixir.Core.Functions.is_instance_of(term, type)
  end

  def global() do
    Elixir.Core.Functions.get_global()
  end

  def is_atom(term) do
    get_type(term) === 'symbol'
  end

  def is_binary(term) do
    get_type(term) === 'string'
  end

  def is_bitstring(term) do
    is_binary(term) || is_instance_of(term, Elixir.Core.BitString)
  end

  def is_boolean(term) do
    get_type(term) === 'boolean' || is_instance_of(term, Boolean)
  end

  def is_float(term) do
    is_number(term) && !Number.isInteger(term)
  end

  def is_function(term) do
    is_function(term, 0)
  end

  def is_function(term, _) do
    get_type(term) === 'function' || is_instance_of(term, Function)
  end

  def is_integer(term) do
    Number.isInteger(term)
  end

  def is_list(term) do
    Array.isArray(term)
  end

  def is_number(term) do
    get_type(term) === 'number' || is_instance_of(term, Number)
  end

  def is_pid(term) do
    is_instance_of(term, Elixir.Core.PID)
  end

  def is_tuple(term) do
    is_instance_of(term, Elixir.Core.Tuple)
  end

  def is_map(term) do
    get_type(term) === 'object' || is_instance_of(term, Object)
  end

  def is_port(_) do
    false
  end

  def is_reference(_) do
    false
  end

  def length(term) do
    term.length
  end

  def map_size(term) do
    Object.keys(term).length
  end

  def max(first, second) do
    Math.max(first, second)
  end

  def min(first, second) do
    Math.min(first, second)
  end

  def round(number) do
    Math.round(number)
  end

  def trunc(number) do
    Math.floor(number)
  end

  def tuple_size(tuple) do
    Elixir.Core.Functions.size(tuple)
  end

  def elem(tuple, index) do
    Elixir.Core.Functions.apply(tuple, "get", [index])
  end

  def is_nil(term) do
    term === nil
  end

  defmacro match?(left, right) do
    quote do
      case unquote(right) do
        unquote(left) ->
          true
        _ ->
          false
      end
    end
  end

  defmacro to_string(arg) when Kernel.is_binary(arg) do
    arg
  end

  defmacro to_string(arg) do
    quote do
      String.Chars.to_string(unquote(arg))
    end
  end

  defmacro left |> {fun, context, params} do
    {fun, context, [left] ++ params }
  end

  defmacro left in right do
    quote do
      Elixir.Core.Functions.contains(unquote(left), unquote(right))
    end
  end

  defmacro first .. last do
    quote do
      %ElixirScript.Range{ first: unquote(first), last: unquote(last) }
    end
  end
end