defmodule MemoryGame.Game do
  @enforce_keys [:cards]
  defstruct [:cards, :winner, :scores, :player_on_turn, attempt: 0]

  alias MemoryGame.Game
  alias MemoryGame.Card
  alias MemoryGame.Player

  @doc """
  Create a game with the given number of card `pairs`
  """
  @spec new(pairs :: number()) :: %Game{}
  def new(pairs) do
    cards =
      pairs
      |> Card.create_cards()
      |> Card.shuffle_and_sort_cards()

    %Game{cards: cards}
  end

  @spec flip_card(game :: %Game{}, card :: %Card{}, player :: %Player{}) :: %Game{}
  def flip_card(game, card, player) do
    updated_game =
      game
      |> update_cards_whit_flipped_card(card, player)
      |> update_cards_whit_flipped_pairs(card, player)

    updated_game

    # |> update_player_attempt()

    # if updated_game.attempt > 1, do: reset_pair_cards(updated_game), else: updated_game
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
      true -> %Card{selected_card | flipped: true, flipped_by: player}
      false -> game_card
    end
  end

  defp update_cards_whit_flipped_pairs(game, card, player) do
    new_cards =
      game.cards
      |> List.flatten()
      |> Enum.map(&mark_pair_as_flipped(&1, card, player))
      |> Enum.chunk_every(Enum.count(game.cards))

    %Game{game | cards: new_cards}
  end

  defp mark_pair_as_flipped(game_card, selected_card, player) do
    with true <- is_pair_or_selected_card(game_card, selected_card),
         true <- game_card.flipped == true,
         true <- game_card.flipped_by == player do
      %Card{selected_card | pair_flipped: true}
    else
      false ->
        game_card
    end
  end

  defp is_pair_or_selected_card(game_card, selected_card) do
    cond do
      game_card.id == selected_card.pair_of == true -> true
      game_card.pair_of == selected_card.id == true -> true
      true -> false
    end
  end

  defp reset_pair_cards(game) do
    new_cards =
      game.cards
      |> List.flatten()
      |> Enum.map(&reset_card(&1))
      |> Enum.chunk_every(Enum.count(game.cards))

    %Game{game | cards: new_cards}
  end

  defp reset_card(card) do
    case card.pair_flipped == false do
      true -> %Card{card | flipped: false, flipped_by: nil, pair_flipped: false}
      false -> card
    end
  end

  defp update_player_attempt(game) do
    %Game{game | attempt: game.attempt + 1}
  end
end
