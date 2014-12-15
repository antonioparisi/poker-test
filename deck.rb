require './card.rb'
require './hand.rb'

class Deck
  def initialize
    @card = Card.new
    @hand = Hand.new

    @game_cards = []
  end

  def start_game
    ##
    # 5 hands per game
    ##

    (1..5).each do |i|
      p "[*] Game's hand Number ##{i}"

      ##
      # Generate random cards for 2 Players
      ##
      @game_cards = (0..1).map { @card.pick_random_cards }

      @card.format_output(@game_cards)

      scores
    end
  end

  ##
  # Handle hand scores
  ##
  def scores
    @hand.analyze(@game_cards)
  end
end
