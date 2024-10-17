defmodule OrdmapTest do
  use ExUnit.Case
  doctest Ordmap

  test "fetch!" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.fetch!(data, 1) == 2
    assert Ordmap.fetch!(data, 3) == 4
  end

  test "fetch" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.fetch(data, 0) == :error
    assert Ordmap.fetch(data, 1) == {:ok, 2}
    assert Ordmap.fetch(data, 2) == :error
    assert Ordmap.fetch(data, 3) == {:ok, 4}
    assert Ordmap.fetch(data, 4) == :error
  end

  test "get" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.get(data, 0) == nil
    assert Ordmap.get(data, 1) == 2
    assert Ordmap.get(data, 2) == nil
    assert Ordmap.get(data, 3) == 4
    assert Ordmap.get(data, 4) == nil
    assert Ordmap.get(data, 4, :default) == :default
  end

  test "put" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.put(data, 0, 5) == [{0, 5}, {1, 2}, {3, 4}]
    assert Ordmap.put(data, 1, 6) == [{1, 6}, {3, 4}]
    assert Ordmap.put(data, 2, 7) == [{1, 2}, {2, 7}, {3, 4}]
  end

  test "update!" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.update!(data, 3, fn data -> data + 123 end) == [{1, 2}, {3, 127}]
    assert Ordmap.update!(data, 1, fn data -> data + 123 end) == [{1, 125}, {3, 4}]
  end

  test "update" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.update(data, 3, :default, fn data -> data + 123 end) == [{1, 2}, {3, 127}]
    assert Ordmap.update(data, 1, :default, fn data -> data + 123 end) == [{1, 125}, {3, 4}]

    assert Ordmap.update(data, 2, :default, fn data -> data + 123 end) == [
             {1, 2},
             {2, :default},
             {3, 4}
           ]
  end
end
