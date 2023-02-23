defmodule MemoryGame.Card do
  @enforce_keys [:id, :pair_of]
  defstruct [:id, :pair_of, :flipped_by, flipped: false]

  alias __MODULE__

  @doc """
  Create a pair of game cards
  """
  @spec new :: [%Card{}]
  def new() do
    first_card_id = UUID.uuid1()
    second_card_id = UUID.uuid1()

    card1 = Card.new(first_card_id, second_card_id)
    card2 = Card.new(second_card_id, first_card_id)

    [card1, card2]
  end

  @doc """
  Create a card with the given `id` and the given `pair_of` id card
  """
  @spec new(id :: String.t(), pair_of :: String.t()) :: %Card{}
  def new(id, pair_of) do
    %Card{id: id, pair_of: pair_of}
  end
end
