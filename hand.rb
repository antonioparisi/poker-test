require './card.rb'

class Hand
  attr_accessor :cards

  OP_CASES = {
    'Pair' => :pair,
    'Two Pairs' => :two_pairs,
    'Three of a Kind' => :three_of_a_kind,
    'Straight' => :straight,
    'Flush' => :flush,
    'Full House' => :full_house,
    'Four of a Kind' => :four_of_a_kind,
    'Straight Flush' => :straight_flush
  }

  def analyze(cards)
    ##
    # Save cards
    ##
    self.cards = cards

    winner = OP_CASES.map { |op|
      ##
      # Get winner hand in order from lowest to highest
      ##

      result = method(op[1]).call()

      result ? result : false
    }.reject { |score| score == false }.reverse.first

    winner = high_card if winner.nil? || winner.empty?

    if winner.fetch(:winner_id, nil).nil?
      p "[*] No one wins - #{winner[:score_type].capitalize}"
    else
      p "[+] Player ##{winner[:winner_id]} wins - #{winner[:score_type].capitalize}"
    end
  end

  private

  ##
  # Manage cards
  ##

  def order_by_face
    ordered_cards = []

    (0..1).each do |i|
      ordered_cards << cards[i].map { |card| Card::VALUES[card[:value]] }
    end

    ##
    # Return winner's hand
    ##
    ordered_cards
  end

  def order_by_suit
    ordered_cards = []

    (0..1).each do |i|
      ordered_cards << cards[i].map { |card| card[:suit] }
    end

    ordered_cards
  end

  def group_hand_by(kind)
    (0..1).map do |player_id|
      kind[player_id].group_by { |s| s }
    end
  end

  def is_flush?(player_hand)
    player_hand.uniq.length == 1
  end

  def is_straight?(player_hand)
    return false if player_hand.uniq.count < 5

    is_straight = true
    prev = player_hand[0]

    player_hand.each_with_index do |n, i|
      next if i == 0

      if n != prev + 1
        is_straight = false

        return
      end
    end

    is_straight
  end

  def find_card_with_same_values(player_hands, same_total, total_pairs)
    winners = []
    remaining_cards = []

    (0..1).each do |player_id|
      player_hand = player_hands[player_id]

      winners << player_id if player_hand.values.reject { |v| v.count < same_total }.count == total_pairs
      remaining_cards << player_hand.values.reject { |v| v.count > 1 }.sort.reverse
    end

    {
      :winners => winners,
      :remaining_cards => remaining_cards
    }
  end

  ##
  # Operations
  ##

  def high_card
    ##
    # TODO: Return the highest card's face
    ##

    winners = []
    score = 'high card'
    faces = order_by_face

    winners = faces.map { |card| card.reduce(&:+) }
    score = 'high card - tie' if winners.reduce(&:%) == 0

    winner_id = winners.each_with_index.max[1] if score != 'tie'

    {
      :score_type => score,
      :winner_id => winner_id
    }
  end

  def pair
    faces = group_hand_by(order_by_face)

    score = find_card_with_same_values(faces, 2, 1)
    winners = score[:winners]
    remaining_cards = score[:remaining_cards]

    if !winners.empty?
      winner_id = winners[0]

      if winners.length == 2
        winner_id = remaining_cards.each_with_index.max[1]
      end

      return {
        :score_type => 'pair',
        :winner_id => winner_id
      }
    end

    false
  end

  def two_pairs
    faces = group_hand_by(order_by_face)

    score = find_card_with_same_values(faces, 2, 2)
    winners = score[:winners]
    remaining_cards = score[:remaining_cards]

    if !winners.empty?
      winner_id = winners[0]

      if winners.length == 2
        winner_id = remaining_cards.each_with_index.max[1]
      end

      return {
        :score_type => 'two pairs',
        :winner_id => winner_id
      }
    end

    false
  end

  def three_of_a_kind
    faces = group_hand_by(order_by_face)

    score = find_card_with_same_values(faces, 3, 1)
    winners = score[:winners]
    remaining_cards = score[:remaining_cards]

    if !winners.empty?
      winner_id = winners[0]

      if winners.length == 2
        winner_id = remaining_cards.each_with_index.max[1]
      end

      return {
        :score_type => 'three of a kind',
        :winner_id => winner_id
      }
    end

    false
  end

  def straight
    winners = []

    faces = order_by_face

    (0..1).each do |player_id|
      winners << player_id if is_straight?(faces[player_id].sort)
    end

    if !winners.empty?
      return high_card if winners.length == 2

      winner_id = winners[0]

      return {
        :score_type => 'straight',
        :winner_id => winner_id
      }

    end

    false
  end

  def flush
    winners = []
    cards = order_by_suit

    (0..1).each do |player_id|
      winners << player_id if is_flush?(cards[player_id])
    end

    if winners.length == 1
      return {
        :score_type => 'flush',
        :winner_id => winners[0]
      }
    end

    high_card if winners.length > 1

    false
  end

  def full_house
    false
  end

  def four_of_a_kind
    winners = []
    faces = order_by_face

    ##
    # Check if there's a four kind
    ##
    group_hand_by(faces).each_with_index do |hand, player_id|
      hand.values.each do |faces|
        winners << [player_id, faces[0]] if faces.length == 4
      end
    end

    if winners.length > 0
      winner_id = winners[0][0]
      score = 'four of a kind'

      if winners.length == 2
        ##
        # Compare faces between two hands
        ##

        score = 'four of a kind - tie' if winners[0][1] == winners[1][1]
        winner_id = winners.each_with_index.max[1]
      end

      return {
        :score_type => score,
        :winner_id => winner_id
      }
    end

    false
  end

  def straight_flush
    winners = []

    suits = order_by_suit
    faces = order_by_face

    ##
    # Check for same suit and straight
    ##

    (0..1).each do |player_id|
      if is_flush?(suits[player_id])
        winners << player_id if is_straight?(faces[player_id].sort)
      end
    end

    if !winners.empty?
      return high_card if winners.length == 2

      winner_id = winners[0]

      return {
        :score_type => 'straight flush',
        :winner_id => winner_id
      }
    end

    false
  end

end
