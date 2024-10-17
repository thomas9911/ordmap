defmodule Ordmap do
  @moduledoc """
  Documentation for `Ordmap`.
  """

  def new, do: []
  def to_list(ordmap), do: ordmap

  def fetch!([{k, _} | d], key) when key > k, do: fetch!(d, key)
  def fetch!([{k, value} | _], key) when key == k, do: value

  def fetch([{k, _} | _], key) when key < k, do: :error
  def fetch([{k, _} | d], key) when key > k, do: fetch(d, key)
  def fetch([{_, value} | _], _), do: {:ok, value}
  def fetch([], _), do: :error

  def get(ordmap, key, default \\ nil)
  def get([{k, _} | _], key, default) when key < k, do: default
  def get([{k, _} | d], key, default) when key > k, do: get(d, key, default)
  def get([{_, value} | _], _, _), do: value
  def get([], _, default), do: default

  def put([{k, _} | _] = dict, key, value) when key < k, do: [{key, value} | dict]
  def put([{k, _} = e | dict], key, value) when key > k, do: [e | put(dict, key, value)]
  def put([{_, _} | dict], key, value), do: [{key, value} | dict]
  def put([], key, value), do: [{key, value}]

  def update!([{k, _} = e | dict], key, func) when key > k do
    [e | update!(dict, key, func)]
  end

  def update!([{k, val} | dict], key, func) when key == k do
    [{key, func.(val)} | dict]
  end

  def update([{k, _} | _] = dict, key, default, _) when key < k do
    [{key, default} | dict]
  end

  def update([{k, _} = e | dict], key, default, func) when key > k do
    [e | update(dict, key, default, func)]
  end

  def update([{_, val} | dict], key, _, func), do: [{key, func.(val)} | dict]
  def update([], key, default, _), do: [{key, default}]
end
