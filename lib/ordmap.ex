defmodule Ordmap do
  @moduledoc """
  Documentation for `Ordmap`.
  """

  defguard is_empty(a) when a == []

  @type t :: [{key, value}]
  @type key :: term
  @type value :: term
  @type default :: term

  @spec new() :: t()
  def new, do: []

  @spec to_list(t()) :: list
  def to_list(ordmap), do: ordmap

  @spec fetch!(t(), key()) :: value()
  def fetch!([{k, _} | d], key) when key > k, do: fetch!(d, key)
  def fetch!([{k, value} | _], key) when key == k, do: value

  @spec fetch(t(), key()) :: {:ok, value()} | :error
  def fetch([{k, _} | _], key) when key < k, do: :error
  def fetch([{k, _} | d], key) when key > k, do: fetch(d, key)
  def fetch([{_, value} | _], _), do: {:ok, value}
  def fetch([], _), do: :error

  @spec get(t(), key()) :: value() | nil
  @spec get(t(), key(), default()) :: value() | default()
  def get(ordmap, key, default \\ nil)
  def get([{k, _} | _], key, default) when key < k, do: default
  def get([{k, _} | d], key, default) when key > k, do: get(d, key, default)
  def get([{_, value} | _], _, _), do: value
  def get([], _, default), do: default

  @spec put(t(), key(), value()) :: t()
  def put([{k, _} | _] = dict, key, value) when key < k, do: [{key, value} | dict]
  def put([{k, _} = e | dict], key, value) when key > k, do: [e | put(dict, key, value)]
  def put([{_, _} | dict], key, value), do: [{key, value} | dict]
  def put([], key, value), do: [{key, value}]

  @spec delete(t(), key()) :: t()
  def delete([{k, _} | _] = dict, key) when key < k, do: dict
  def delete([{k, _} = e | dict], key) when key > k, do: [e | delete(dict, key)]
  def delete([{_, _} | dict], _), do: dict
  def delete([], _), do: []

  @spec update!(t(), key(), (value() -> value())) :: t()
  def update!([{k, _} = e | dict], key, func) when key > k do
    [e | update!(dict, key, func)]
  end

  def update!([{k, val} | dict], key, func) when key == k do
    [{key, func.(val)} | dict]
  end

  @spec update(t(), key(), default(), (value() -> value())) :: t()
  def update([{k, _} | _] = dict, key, default, _) when key < k do
    [{key, default} | dict]
  end

  def update([{k, _} = e | dict], key, default, func) when key > k do
    [e | update(dict, key, default, func)]
  end

  def update([{_, val} | dict], key, _, func), do: [{key, func.(val)} | dict]
  def update([], key, default, _), do: [{key, default}]

  @spec has_key?(t(), key()) :: boolean
  def has_key?([{k, _} | _], key) when key < k, do: false
  def has_key?([{k, _} | dict], key) when key > k, do: has_key?(dict, key)
  def has_key?([{_, _} | _], _), do: true
  def has_key?([], _), do: false
end
