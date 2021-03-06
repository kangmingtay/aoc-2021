defmodule Day3.Part1 do
  def parse_input(path) do
    path
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)  
  end

  def sol1(path) do
    path
    |> parse_input()
    |> then(fn rows -> 
      acc = rows |> get_one |> init_acc
      Enum.reduce(rows, acc, fn row, acc ->
        row
        |> Enum.zip(acc)
        |> Enum.map(fn { val, { zeros, ones } } -> 
          case val do
            "0" -> { zeros + 1, ones }
            "1" -> { zeros, ones + 1 }
          end
        end)
      end)
    end)
    |> Enum.map(fn { zeros, ones } ->
      cond do
        zeros > ones -> 0
        zeros < ones -> 1
        :otherwise -> 1
      end
    end) 
    |> Enum.map(&most_common/1)
    |> then(fn row ->
      { gamma_row, epsilon_row } = row |> Enum.unzip()
      gamma = gamma_row |> Enum.map(&bool_to_int/1) |> result_to_binary_list()   
      epsilon = epsilon_row |> Enum.map(&bool_to_int/1) |> result_to_binary_list()
      gamma * epsilon
    end)
  end

  def result_to_binary_list(res) do
    res 
    |> Enum.map(&Integer.to_string/1)
    |> List.to_string()
    |> String.to_integer(2)
  end

  def get_one(rows), do: List.first(rows)

  def init_acc([_]), do: [ { 0, 0 } ]
  def init_acc([_head | tail]), do: [ { 0, 0 } | init_acc(tail)] 
         
  def most_common(num) do
    cond do
      num > 0 -> { true, false }
      num <= 0 -> { false, true }
    end
  end

  def bool_to_int(true), do: 1
  def bool_to_int(false), do: 0
end
