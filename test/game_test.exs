defmodule GameTest do
  use ExUnit.Case
  import Mock

  defp create_cards_mock do
    card1 = MemoryGame.Card.new(1, 2)
    card2 = MemoryGame.Card.new(2, 1)
    card3 = MemoryGame.Card.new(3, 4)
    card4 = MemoryGame.Card.new(4, 3)

    [[card1, card2], [card3, card4]]
  end

  describe "when create a new game" do
    setup do
      cards = create_cards_mock()
      {:ok, player: MemoryGame.Player.new("Julito"), cards: cards}
    end

    test_with_mock "should create game cards correctly",
                   %{player: _player, cards: cards} = _context,
                   MemoryGame.Card,
                   [],
                   create_cards: fn _pairs -> cards end,
                   shuffle_and_sort_cards: fn _cards -> cards end do
      expected_game = %MemoryGame.Game{
        attempt: 0,
        player_on_turn: nil,
        scores: nil,
        winner: nil,
        cards: [
          [
            %MemoryGame.Card{
              id: 1,
              pair_of: 2,
              flipped: false,
              flipped_by: nil,
              pair_flipped: false
            },
            %MemoryGame.Card{
              id: 2,
              pair_of: 1,
              flipped: false,
              flipped_by: nil,
              pair_flipped: false
            }
          ],
          [
            %MemoryGame.Card{
              id: 3,
              pair_of: 4,
              flipped: false,
              flipped_by: nil,
              pair_flipped: false
            },
            %MemoryGame.Card{
              id: 4,
              pair_of: 3,
              flipped: false,
              flipped_by: nil,
              pair_flipped: false
            }
          ]
        ]
      }

      game = MemoryGame.Game.new(2)
      assert expected_game == game
    end
  end
end
