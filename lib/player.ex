defmodule MemoryGame.Player do
  @enforce_keys [:name]
  defstruct [:name]

  @doc """
  Create a new player with the given `name`
  """
  @spec new(name :: String.t()) :: %__MODULE__{}
  def new(name) do
    %__MODULE__{name: name}
  end
end
