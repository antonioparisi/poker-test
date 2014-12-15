class Card
  SUITS = {
    'C' => 0,
    'D' => 1,
    'H' => 2,
    'S' => 3
  }

  VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }

  def pick_random_cards
    (0..4).to_a.map do |i|
      {
        :value => VALUES.keys[rand(VALUES.length)],
        :suit => SUITS.keys[rand(SUITS.length)]
      }
    end
  end

  def format_output(cards)
    cards.each_with_index do |player_cards, player_number|
      ##
      # Format output to display player cards
      ##

      card = player_cards.map { |card| "#{card[:value]}#{card[:suit]}" }
      card = card.join(' ')

      p "Player ##{player_number}: #{card}"
    end
  end
end
