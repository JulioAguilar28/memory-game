defmodule MemoryGame.Game do
  defstruct [:cards, :winner, :scores]
  @enforce_keys [:cards]

  alias MemoryGame.Game
  alias MemoryGame.Card

  def new(size) do
    cards =
      size
      |> create_cards()
      |> Enum.reduce(fn cards_list, acc -> cards_list ++ acc end)
      |> Enum.shuffle()
      |> Enum.chunk_every(trunc(size / 2) + 1)

    %Game{cards: cards}
  end

  @doc """
  Create a game cards whit the given `size`
  """
  @spec create_cards(size :: number()) :: [[%Card{}]]
  def create_cards(size) do
    create_cards([], size)
  end

  defp create_cards(cards, 0), do: cards

  defp create_cards(cards, size) do
    create_cards([Card.new() | cards], size - 1)
  end
end
