defmodule MemoryGame.Card do
  @enforce_keys [:id]
  defstruct [:id, :flipped_by, flipped: false]

  alias __MODULE__

  @spec new :: [%Card{}]
  @doc """
  Create a pair of game cards
  """
  def new() do
    UUID.uuid1()
    |> new()
    |> create_card_pair()
  end

  @doc """
  Create a card with the given `id`
  """
  @spec new(id :: String.t()) :: %Card{}
  def new(id) do
    %Card{id: id}
  end

  @doc """
  Create a game card pair with the given `card`
  """
  @spec create_card_pair(card :: %Card{}) :: [%Card{}]
  def create_card_pair(card) do
    [card, card]
  end
end
