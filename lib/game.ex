defmodule MemoryGame.Game do
  @enforce_keys [:cards]
  defstruct [:cards, :winner, :scores, :player_on_turn, selected_cards: [], attempt: 0]

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
    game
    |> update_player_attempt()
    |> update_game_cards(card, player)
    |> validate_selected_cards()
  end

  defp validate_selected_cards(%Game{attempt: 2} = game) do
    [card1, card2] = game.selected_cards

    cards =
      case card1.id == card2.pair_of do
        true ->
          game.cards

        false ->
          reset_no_pair_cards(game.cards, [card1.id, card2.id])
      end

    %Game{game | cards: cards, selected_cards: []}
  end

  defp validate_selected_cards(game), do: game

  defp reset_no_pair_cards(game_cards, selected_cards_ids) do
    game_cards
    |> List.flatten()
    |> Enum.map(&reset_card(&1, selected_cards_ids))
    |> Enum.chunk_every(Enum.count(game_cards))
  end

  defp reset_card(game_card, ids) do
    case Enum.any?(ids, fn id -> game_card.id == id end) do
      true ->
        %Card{game_card | flipped: false, flipped_by: nil}

      false ->
        game_card
    end
  end

  defp update_game_cards(game, card, player) do
    new_cards =
      game.cards
      |> List.flatten()
      |> Enum.map(&flip_selected_card(&1, card, player))
      |> Enum.chunk_every(Enum.count(game.cards))

    selected_card =
      game.cards
      |> List.flatten()
      |> Enum.find(fn game_card -> game_card.id == card.id end)
      |> Map.update(:flipped, false, fn _ -> true end)
      |> Map.update(:flipped_by, nil, fn _ -> player end)

    %Game{game | cards: new_cards, selected_cards: [selected_card | game.selected_cards]}
  end

  defp flip_selected_card(game_card, selected_card, player) do
    case game_card.id == selected_card.id do
      true -> %{game_card | flipped: true, flipped_by: player}
      false -> game_card
    end
  end

  defp update_player_attempt(game) do
    attempt = if game.attempt < 2, do: game.attempt + 1, else: 0

    %Game{game | attempt: attempt}
  end
end
