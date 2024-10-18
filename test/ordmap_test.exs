defmodule OrdmapTest do
  use ExUnit.Case, async: true
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

  test "delete" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.delete(data, 0) == data
    assert Ordmap.delete(data, 1) == [{3, 4}]
    assert Ordmap.delete(data, 2) == data
    assert Ordmap.delete(data, 3) == [{1, 2}]
  end

  test "update!" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.update!(data, 3, &(&1 + 123)) == [{1, 2}, {3, 127}]
    assert Ordmap.update!(data, 1, &(&1 + 123)) == [{1, 125}, {3, 4}]
  end

  test "update" do
    data = [{1, 2}, {3, 4}]
    assert Ordmap.update(data, 3, :default, &(&1 + 123)) == [{1, 2}, {3, 127}]
    assert Ordmap.update(data, 1, :default, &(&1 + 123)) == [{1, 125}, {3, 4}]

    assert Ordmap.update(data, 2, :default, &(&1 + 123)) == [
             {1, 2},
             {2, :default},
             {3, 4}
           ]
  end

  test "has_key?" do
    refute Ordmap.has_key?([{1, 3}, {2, 4}], 0)
    assert Ordmap.has_key?([{1, 3}, {2, 4}], 1)
    assert Ordmap.has_key?([{1, 3}, {2, 4}], 2)
    refute Ordmap.has_key?([{1, 3}, {2, 4}], 3)
  end

  test "is_empty" do
    assert Ordmap.is_empty(Ordmap.new())
    refute Ordmap.is_empty([{1, 2}])
  end
end
