defmodule MemoryGame.Game do
  @enforce_keys [:cards]
  defstruct [:cards, :winner, :scores, attempt: 0]

  alias MemoryGame.Game
  alias MemoryGame.Card
  alias MemoryGame.Player

  @doc """
  Create a game whit the given number of card `pairs`
  """
  @spec new(pairs :: number()) :: %Game{}
  def new(pairs) do
    cards =
      pairs
      |> create_cards()
      |> List.flatten()
      |> Enum.shuffle()
      |> Enum.chunk_every(trunc(pairs / 2) + 1)

    %Game{cards: cards}
  end

  @spec flip_card(game :: %Game{}, card :: %Card{}, player :: %Player{}) :: %Game{}
  def flip_card(game, card, player) do
    game
    |> update_cards_whit_flipped_card(card, player)
    |> update_player_attempt()
  end

  defp update_cards_whit_flipped_card(game, card, player) do
    new_cards =
      game.cards
      |> List.flatten()
      |> Enum.map(&mark_card_as_flipped(&1, card, player))
      |> Enum.chunk_every(Enum.count(game.cards))

    %Game{game | cards: new_cards}
  end

  defp mark_card_as_flipped(game_card, selected_card, player) do
    case game_card.id == selected_card.id do
      true -> %Card{game_card | flipped: true, flipped_by: player}
      false -> game_card
    end
  end

  defp update_player_attempt(game) do
    %Game{game | attempt: game.attempt + 1}
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
