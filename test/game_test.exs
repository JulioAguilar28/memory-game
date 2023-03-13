defmodule GameTest do
  use ExUnit.Case
  import Mock

  alias MemoryGame.{
    Player,
    Card,
    Game
  }

  describe "when create a new game" do
    setup do
      cards = GameFixtures.create_cards_mock()
      {:ok, player: Player.new("user_1"), cards: cards}
    end

    test_with_mock "should create game cards correctly",
                   %{player: _player, cards: cards} = _context,
                   Card,
                   [],
                   create_cards: fn _pairs -> cards end,
                   shuffle_and_sort_cards: fn _cards -> cards end do
      expected_game = %Game{
        attempt: 0,
        player_on_turn: nil,
        scores: nil,
        winner: nil,
        cards: [
          [
            %Card{
              id: 1,
              pair_of: 2,
              flipped: false,
              flipped_by: nil
            },
            %Card{
              id: 2,
              pair_of: 1,
              flipped: false,
              flipped_by: nil
            }
          ],
          [
            %Card{
              id: 3,
              pair_of: 4,
              flipped: false,
              flipped_by: nil
            },
            %Card{
              id: 4,
              pair_of: 3,
              flipped: false,
              flipped_by: nil
            }
          ]
        ]
      }

      game = Game.new(2)
      assert expected_game == game
    end
  end

  describe "when user_1 user flip a card" do
    setup do
      {:ok, player: Player.new("user_1"), game: GameFixtures.create_new_game_mock()}
    end

    test "should flip the selected card by user_1", %{player: player, game: game} do
      expected_cards = [
        [
          %MemoryGame.Card{
            id: 1,
            pair_of: 2,
            flipped: false,
            flipped_by: nil
          },
          %MemoryGame.Card{
            id: 2,
            pair_of: 1,
            flipped: true,
            flipped_by: player
          }
        ],
        [
          %MemoryGame.Card{
            id: 3,
            pair_of: 4,
            flipped: false,
            flipped_by: nil
          },
          %MemoryGame.Card{
            id: 4,
            pair_of: 3,
            flipped: false,
            flipped_by: nil
          }
        ]
      ]

      card = Card.new(2, 1)
      game = Game.flip_card(game, card, player)

      assert game.cards == expected_cards
    end

    test "should add the selected card to selected_cards list", %{player: player, game: game} do
      expected_selected_cards = [
        %Card{
          id: 2,
          pair_of: 1,
          flipped: true,
          flipped_by: player
        }
      ]

      card = Card.new(2, 1)
      game = Game.flip_card(game, card, player)

      assert game.selected_cards == expected_selected_cards
    end

    test "should update game attemp", %{player: player, game: game} do
      card = Card.new(2, 1)
      game = Game.flip_card(game, card, player)

      assert game.attempt == 1
    end
  end

  describe "when user_1 flip a second card and card pair is already flipped" do
    setup do
      game = GameFixtures.create_new_game_mock()
      player = Player.new('user_1')

      game = %{
        game
        | cards: [
            [
              %Card{
                id: 1,
                pair_of: 2,
                flipped: false,
                flipped_by: nil
              },
              %Card{
                id: 2,
                pair_of: 1,
                flipped: true,
                flipped_by: player
              }
            ],
            [
              %Card{
                id: 3,
                pair_of: 4,
                flipped: false,
                flipped_by: nil
              },
              %Card{
                id: 4,
                pair_of: 3,
                flipped: false,
                flipped_by: nil
              }
            ]
          ],
          selected_cards: [
            %Card{
              id: 2,
              pair_of: 1,
              flipped: true,
              flipped_by: player
            }
          ],
          attempt: 1
      }

      {:ok, player: player, game: game}
    end

    test "should mark boths cards as flipped by user_1", %{player: player, game: game} do
      expected_cards = [
        [
          %Card{
            id: 1,
            pair_of: 2,
            flipped: true,
            flipped_by: player
          },
          %Card{
            id: 2,
            pair_of: 1,
            flipped: true,
            flipped_by: player
          }
        ],
        [
          %Card{
            id: 3,
            pair_of: 4,
            flipped: false,
            flipped_by: nil
          },
          %Card{
            id: 4,
            pair_of: 3,
            flipped: false,
            flipped_by: nil
          }
        ]
      ]

      card = Card.new(1, 2)
      game = Game.flip_card(game, card, player)

      assert game.cards == expected_cards
    end

    test "should clear selected cards list", %{player: player, game: game} do
      card = Card.new(1, 2)
      game = Game.flip_card(game, card, player)

      assert game.selected_cards == []
    end

    test "should update game attempt", %{player: player, game: game} do
      card = Card.new(1, 2)
      game = Game.flip_card(game, card, player)

      assert game.attempt == 2
    end
  end

  describe "when user_1 flip a second card and does not match" do
    setup do
      game = GameFixtures.create_new_game_mock()
      player = Player.new('user_1')

      game = %{
        game
        | cards: [
            [
              %Card{
                id: 1,
                pair_of: 2,
                flipped: false,
                flipped_by: nil
              },
              %Card{
                id: 2,
                pair_of: 1,
                flipped: true,
                flipped_by: player
              }
            ],
            [
              %Card{
                id: 3,
                pair_of: 4,
                flipped: false,
                flipped_by: nil
              },
              %Card{
                id: 4,
                pair_of: 3,
                flipped: false,
                flipped_by: nil
              }
            ]
          ],
          selected_cards: [
            %Card{
              id: 2,
              pair_of: 1,
              flipped: true,
              flipped_by: player
            }
          ],
          attempt: 1
      }

      card = Card.new(3, 4)
      game = Game.flip_card(game, card, player)

      {:ok, player: player, game: game}
    end

    test "should flip back the flipped cards", %{game: game} do
      expected_cards = [
        [
          %Card{
            id: 1,
            pair_of: 2,
            flipped: false,
            flipped_by: nil
          },
          %Card{
            id: 2,
            pair_of: 1,
            flipped: false,
            flipped_by: nil
          }
        ],
        [
          %Card{
            id: 3,
            pair_of: 4,
            flipped: false,
            flipped_by: nil
          },
          %Card{
            id: 4,
            pair_of: 3,
            flipped: false,
            flipped_by: nil
          }
        ]
      ]

      assert game.cards == expected_cards
    end

    test "should clear the selected cards list", %{game: game} do
      assert game.selected_cards == []
    end

    test "should update game attemps", %{game: game} do
      assert game.attempt == 2
    end
  end
end

defmodule GameFixtures do
  alias MemoryGame.{
    Game,
    Card,
    Player
  }

  def create_cards_mock do
    card1 = Card.new(1, 2)
    card2 = Card.new(2, 1)
    card3 = Card.new(3, 4)
    card4 = Card.new(4, 3)

    [[card1, card2], [card3, card4]]
  end

  def create_new_game_mock() do
    %Game{
      attempt: 0,
      selected_cards: [],
      player_on_turn: nil,
      scores: nil,
      winner: nil,
      cards: [
        [
          %MemoryGame.Card{
            id: 1,
            pair_of: 2,
            flipped: false,
            flipped_by: nil
          },
          %MemoryGame.Card{
            id: 2,
            pair_of: 1,
            flipped: false,
            flipped_by: nil
          }
        ],
        [
          %MemoryGame.Card{
            id: 3,
            pair_of: 4,
            flipped: false,
            flipped_by: nil
          },
          %MemoryGame.Card{
            id: 4,
            pair_of: 3,
            flipped: false,
            flipped_by: nil
          }
        ]
      ]
    }
  end
end
