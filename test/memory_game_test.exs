defmodule MemoryGameTest do
  use ExUnit.Case
  doctest MemoryGame

  test "greets the world" do
    assert MemoryGame.hello() == :world
  end
end
